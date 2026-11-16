# coding=utf-8

"""
PESAD engine layer.

The single Python interface to the Prolog expert system, shared by the
Telegram bot (telegram_bot/) and the web API (web_api/).

The engine runs in one SWI-Prolog process driven over the Machine Query
Interface (library(mqi), via the `swiplserver` package). Every consultation is
a worker thread on the Prolog side (see prolog/bot_session.pl) that runs the
ordinary main/0 and stops at each question; a question is returned here as a
`Screen`, which holds the console text (what the bot shows), the kind of
answer expected and a structured description of the question (what the web
API shows).

Three ways of using it:
  - turn by turn with `open`, `answer` and `cancel`, passing the raw answers
    as typed (the bot);
  - stateless, with `consult(lang, answers)`, which starts a fresh session
    for a language, replays the answers after validating each one against
    the options of its screen, and returns the screen reached (the web API);
  - without questions, with `evaluate(request)`, on facts and test results
    given at once (POST /evaluate of the web API).

Author: Donato Meoli
"""

import asyncio
import json
import os
import uuid
from dataclasses import dataclass

from swiplserver import PrologMQI

PESAD_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BOOTSTRAP = os.path.join(PESAD_DIR, "prolog", "bot_boot.pl")

LANGUAGES = {"en": "1", "it": "2"}  # answers to the language question
METHODS = {"cf": "1", "fuzzy": "2", "fuzzy_membership": "3",  # answers to the
           "lukasiewicz": "4", "hamacher": "5", "einstein": "6"}  # method question
CERTAINTY_VALUES = ("0.0", "0.25", "0.5", "0.75", "1.0")


class InvalidAnswer(ValueError):
    """An answer that is not among the options of its screen."""

    def __init__(self, index, value):
        super().__init__(f"invalid answer #{index}: {value!r}")
        self.index = index
        self.value = value


@dataclass
class Screen:
    """One turn of a consultation.

    `kind` is the kind of answer the engine waits for (language, method,
    command, simple, criterion, certainty, menu, menu_why, number) or 'final';
    `text` is the console output of the turn; `topic` is the structured
    description of the question (see topic_json/2 in prolog/bot_io.pl), or
    None when the turn has none."""

    kind: str
    text: str
    topic: dict | None = None

    @property
    def type(self):
        """'criterion', 'certainty', 'choice', 'number', 'diagnosis' or None."""
        return self.topic["type"] if self.topic else None

    def options(self):
        """The answer options as a list of {'value', 'label'} dicts."""
        if self.type == "certainty":
            return [{"value": v, "label": v} for v in CERTAINTY_VALUES]
        if self.type in ("criterion", "choice", "number"):
            return list(self.topic["options"])
        return []

    def encode(self, value):
        """The raw engine answer for the option `value`, or None if `value`
        is not a valid answer to this screen."""
        if not isinstance(value, str):
            return None
        if self.type in ("criterion", "certainty"):
            return value if value in (o["value"] for o in self.options()) else None
        if self.type == "choice":  # options are chosen by index in the engine
            for i, option in enumerate(self.topic["options"], start=1):
                if option["value"] == value:
                    return str(i)
            return None
        if self.type == "number":  # the options are typical values only
            try:
                return value if float(value) >= 0 else None
            except ValueError:
                return None
        return None


def pl_str(value):
    """Render a Python value as a Prolog double-quoted string literal."""
    s = str(value).replace("\\", "\\\\").replace('"', '\\"')
    return f'"{s}"'


def pl_atom(value):
    """Render a path/atom as a Prolog single-quoted atom literal."""
    s = str(value).replace("\\", "\\\\").replace("'", "\\'")
    return f"'{s}'"


def _screen(result):
    """Build a Screen from a swiplserver result, or raise."""
    if not result or result is True:
        raise RuntimeError(f"unexpected Prolog result: {result!r}")
    sol = result[0]
    topic = str(sol["Topic"])
    return Screen(str(sol["Kind"]), str(sol["Text"]),
                  json.loads(topic) if topic else None)


class Engine:
    """The PESAD engine: one MQI connection, serialised with an asyncio lock."""

    def __init__(self):
        self._mqi = None
        self._thread = None
        self._lock = asyncio.Lock()

    def _connect(self):
        # A Unix domain socket instead of TCP: about 1 ms per query instead
        # of 40 ms, which matters when a whole consultation is replayed.
        self._mqi = PrologMQI(unix_domain_socket="")
        self._thread = self._mqi.create_thread()
        self._thread.query(f"consult({pl_atom(BOOTSTRAP)})")

    async def start(self):
        await asyncio.to_thread(self._connect)

    async def stop(self):
        if self._mqi is not None:
            await asyncio.to_thread(self._mqi.stop)

    async def _query(self, goal):
        async with self._lock:
            return await asyncio.to_thread(self._thread.query, goal)

    async def label(self, lang, key):
        """The localized label `key` (e.g. 'disclaimer') in `lang`."""
        result = await self._query(f"label({lang}, {key}, Text)")
        return str(result[0]["Text"])

    async def open(self, session_id):
        """(Re)start a consultation: its first screen asks the language."""
        return _screen(await self._query(
            f"bot_start({pl_str(session_id)}, Kind, Text, Topic)"))

    async def answer(self, session_id, raw):
        """Deliver a raw answer and return the next screen."""
        return _screen(await self._query(
            f"bot_answer({pl_str(session_id)}, {pl_str(raw)}, Kind, Text, Topic)"))

    async def evaluate(self, request):
        """Evaluation from facts (see prolog/evaluate.pl): `request` is the
        dict of POST /evaluate; returns the response dict, or a dict with
        "error" and "index" for an invalid request. Runs in a Prolog thread
        of its own, so it shares no state with the consultations."""
        result = await self._query(
            f"pesad_evaluate({pl_str(json.dumps(request))}, Out)")
        return json.loads(str(result[0]["Out"]))

    async def findings(self):
        """The findings, items, choices and numbers /evaluate accepts."""
        result = await self._query("findings_catalogue(Out)")
        return json.loads(str(result[0]["Out"]))

    async def cancel(self, session_id):
        await self._query(f"bot_cancel({pl_str(session_id)})")

    async def replay(self, session_id, raws):
        """Restart a consultation and re-feed the raw answers `raws`."""
        screen = await self.open(session_id)
        for raw in raws:
            screen = await self.answer(session_id, raw)
        return screen

    async def begin(self, session_id, lang, method="cf"):
        """Start an investigation in `lang` with the uncertainty `method`
        (a key of METHODS), and return its first question."""
        return await self.replay(
            session_id, [LANGUAGES[lang], METHODS[method], "investigation"])

    async def consult(self, lang, answers, method="cf", chapters=None):
        """Stateless consultation: start a fresh session in `lang`, apply the
        option values `answers` in order and return the screen reached.
        With `chapters` (a list of chapter names) the area question is
        answered with them and takes no answer of `answers`. Raises
        InvalidAnswer for the first answer that is not an option of its
        screen. The session is always discarded."""
        session_id = "web-" + uuid.uuid4().hex
        try:
            screen = await self.begin(session_id, lang, method)
            answers = iter(enumerate(answers))
            while True:
                if chapters and screen.type == "choice" and screen.topic["id"] == "area":
                    screen = await self.answer(session_id, ",".join(chapters))
                    continue
                index, value = next(answers, (None, None))
                if index is None:
                    return screen
                raw = screen.encode(value)
                if raw is None:
                    raise InvalidAnswer(index, value)
                screen = await self.answer(session_id, raw)
        finally:
            await self.cancel(session_id)
