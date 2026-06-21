#!/usr/bin/env python3
# coding=utf-8

"""
PESAD Telegram bot.

Front-end that makes the PESAD Prolog expert system (a blocking terminal REPL)
available as a Telegram bot, without rewriting the inference engine.

How it works
------------
The engine is driven over the SWI-Prolog Machine Query Interface (library(mqi),
via the `swiplserver` package). On the Prolog side (see ../bot_boot.pl and
../bot_session.pl) every chat owns a dedicated worker thread that runs the usual
`main/0` consultation; each interactive `read/1` was replaced by `ui_read/2`,
which suspends the worker on a message queue until the next answer arrives.

So the bot only ever exchanges *turns* with Prolog:
  - bot_start(SessionId, Kind, Text)         -> first turn of a new consultation
  - bot_answer(SessionId, Raw, Kind, Text)   -> deliver an answer, get next turn
  - bot_cancel(SessionId)                    -> abort a consultation

`Kind` tells us which keyboard to render; `Text` is the captured console output
to display. `Kind == 'final'` means the consultation ended (Text is its epilogue).

Author: Donato Meoli
"""

import asyncio
import logging
import os
import re

from swiplserver import PrologMQI
from telegram import (Update, InlineKeyboardButton, InlineKeyboardMarkup,
                      constants)
from telegram.ext import (Application, CommandHandler, CallbackQueryHandler,
                          MessageHandler, ContextTypes, filters)

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO,
)
logger = logging.getLogger("pesad-bot")

# --------------------------------------------------------------------------- #
# Paths / configuration
# --------------------------------------------------------------------------- #

PESAD_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BOOTSTRAP = os.path.join(PESAD_DIR, "bot_boot.pl")
TG_MAX = constants.MessageLimit.MAX_TEXT_LENGTH  # 4096

DISCLAIMER = (
    "⚠️ *PESAD* is an academic rule-based expert system over the DSM-5-TR "
    "criteria. It is *not* a medical device and does *not* replace a qualified "
    "mental-health professional. Use it for educational purposes only.\n"
    "_PESAD è un sistema esperto accademico a scopo didattico: non sostituisce "
    "il parere di un professionista._"
)

# Command buttons (Kind == 'command'); the payloads are the engine commands.
COMMANDS = [
    ("🔎 investigation", "investigation"),
    ("🎯 control", "control"),
    ("📋 facts", "facts"),
    ("ℹ️ help", "help"),
    ("🧹 clean", "clean"),
    ("🚪 quit", "quit"),
]

# Certainty presets (Kind == 'certainty'); payloads must be floats for the engine.
CERTAINTIES = [
    ("0.0", "0.0"), ("0.25", "0.25"), ("0.5", "0.5"),
    ("0.75", "0.75"), ("1.0", "1.0"),
]

OPTION_RE = re.compile(r"^[ \t]*(\d+):[ \t]*(.+?)[ \t]*$", re.MULTILINE)


# --------------------------------------------------------------------------- #
# Prolog bridge (single MQI connection, serialised with an asyncio lock)
# --------------------------------------------------------------------------- #

class PrologBridge:
    def __init__(self):
        self._mqi = None
        self._thread = None
        self._lock = asyncio.Lock()

    def _connect(self):
        self._mqi = PrologMQI()
        self._thread = self._mqi.create_thread()
        self._thread.query(f"consult({pl_atom(BOOTSTRAP)})")
        logger.info("Prolog engine loaded from %s", BOOTSTRAP)

    async def start(self):
        await asyncio.to_thread(self._connect)

    async def stop(self):
        if self._mqi is not None:
            await asyncio.to_thread(self._mqi.stop)

    async def _query(self, goal):
        async with self._lock:
            return await asyncio.to_thread(self._thread.query, goal)

    async def turn_start(self, session_id):
        goal = f"bot_start({pl_str(session_id)}, Kind, Text)"
        return _solution(await self._query(goal))

    async def turn_answer(self, session_id, raw):
        goal = f"bot_answer({pl_str(session_id)}, {pl_str(raw)}, Kind, Text)"
        return _solution(await self._query(goal))

    async def cancel(self, session_id):
        await self._query(f"bot_cancel({pl_str(session_id)})")


def _solution(result):
    """Extract (Kind, Text) from a swiplserver result, or raise."""
    if not result or result is True:
        raise RuntimeError(f"unexpected Prolog result: {result!r}")
    sol = result[0]
    return str(sol["Kind"]), str(sol["Text"])


def pl_str(value):
    """Render a Python value as a Prolog double-quoted string literal."""
    s = str(value).replace("\\", "\\\\").replace('"', '\\"')
    return f'"{s}"'


def pl_atom(value):
    """Render a path/atom as a Prolog single-quoted atom literal."""
    s = str(value).replace("\\", "\\\\").replace("'", "\\'")
    return f"'{s}'"


# --------------------------------------------------------------------------- #
# Rendering: turn -> (message text, inline keyboard)
# --------------------------------------------------------------------------- #

def strip_prompts(text):
    """Drop the trailing '>' input markers the terminal REPL prints."""
    lines = []
    for line in text.splitlines():
        s = line.rstrip()
        while s.endswith(">"):
            s = s[:-1].rstrip()
        lines.append(s)
    return re.sub(r"\n{3,}", "\n\n", "\n".join(lines)).strip()


def numbered_keyboard(text, add_why=False):
    """Build a keyboard from the '\\tN: label' option lines in `text`."""
    rows = []
    for num, label in OPTION_RE.findall(text):
        label = label.strip()
        if len(label) > 60:
            label = label[:57] + "…"
        rows.append([InlineKeyboardButton(f"{num}. {label}", callback_data=num)])
    if add_why:
        rows.append([InlineKeyboardButton("❓ why / perché", callback_data="why")])
    return InlineKeyboardMarkup(rows) if rows else None


BACK_BUTTON = InlineKeyboardButton("◀️ back / indietro", callback_data="back")


METHOD_HELP = {
    "it": ("ℹ️ Come vengono combinate le incertezze:\n"
           "1 · Fattori di certezza — t-norma minimo, prudente e robusto (consigliato)\n"
           "2 · Fuzzy (prodotto) — combinazione più morbida: le incertezze si moltiplicano\n"
           "3 · Fuzzy con funzioni di appartenenza — chiede durate/frequenze numeriche e le sfuma\n"
           "Nel dubbio scegli 1."),
    "en": ("ℹ️ How the uncertainties are combined:\n"
           "1 · Certainty factors — minimum t-norm, cautious and robust (recommended)\n"
           "2 · Fuzzy (product) — softer combination: uncertainties multiply\n"
           "3 · Fuzzy with membership functions — asks numeric durations/frequencies and grades them\n"
           "If unsure, pick 1."),
}


def clean_command_body(text):
    """Turn the terminal's ASCII-boxed welcome / command menu into clean text.
    The command buttons already list the commands, so the textual menu is
    dropped; the dashed box is removed and the presentation lines kept."""
    lines = []
    for raw in text.splitlines():
        s = raw.strip()
        if s and set(s) <= set("- "):       # horizontal rule made of dashes
            continue
        if s.startswith("--"):              # boxed presentation line
            lines.append(re.sub(r"\s{2,}", " ", s.lstrip("-").strip()))
            continue
        lines.append(raw.rstrip())
    body = "\n".join(lines)
    body = re.sub(r"(?is)\n?(Available commands|Comandi disponibili)\s*:.*$", "", body)
    body = re.sub(r"\n{3,}", "\n\n", body).strip()
    return ("🧠 " + body) if "PESAD" in body else body


def render(kind, text, lang="en"):
    """Return (display_text, InlineKeyboardMarkup|None) for a turn.

    A '◀️ back' button is appended to every prompt except the first one
    (language selection); tapping it replays the consultation up to the
    previous answer (see push_answer)."""
    if kind in ("language", "method", "menu", "menu_why"):
        body = strip_prompts(OPTION_RE.sub("", text))
        keyboard = numbered_keyboard(text, add_why=(kind == "menu_why"))
        rows = [list(r) for r in keyboard.inline_keyboard] if keyboard else []
        if kind == "method":
            if rows:                         # flag option 1 as the default
                first = rows[0][0]
                rows[0][0] = InlineKeyboardButton(first.text + "  ✅",
                                                  callback_data=first.callback_data)
            body = (body + "\n\n" + METHOD_HELP.get(lang, METHOD_HELP["en"])).strip()
    elif kind == "command":
        rows = [[InlineKeyboardButton(lbl, callback_data=cmd)]
                for lbl, cmd in COMMANDS]
        body = clean_command_body(text) or "Choose a command / Scegli un comando:"
    elif kind == "simple":
        rows = [[InlineKeyboardButton("✅ yes / sì", callback_data="yes"),
                 InlineKeyboardButton("❌ no", callback_data="no")]]
        body = strip_prompts(text)
    elif kind == "criterion":
        rows = [[InlineKeyboardButton("✅ yes / sì", callback_data="yes"),
                 InlineKeyboardButton("❌ no", callback_data="no")],
                [InlineKeyboardButton("❓ why / perché", callback_data="why")]]
        body = strip_prompts(text)
    elif kind == "certainty":
        rows = [[InlineKeyboardButton(lbl, callback_data=val)
                 for lbl, val in CERTAINTIES]]
        body = strip_prompts(text)
    elif kind == "number":
        rows = []
        hint = ("⌨️ Scrivi un numero e invialo." if lang == "it"
                else "⌨️ Type a number and send it.")
        body = strip_prompts(text) + "\n\n" + hint
    else:  # final / expired / unknown
        return strip_prompts(text), None

    if kind != "language":
        rows = rows + [[BACK_BUTTON]]
    keyboard = InlineKeyboardMarkup(rows) if rows else None
    return body, keyboard


def chunks(text):
    """Split a long message under Telegram's per-message limit (on line breaks)."""
    text = text or "…"
    while len(text) > TG_MAX:
        cut = text.rfind("\n", 0, TG_MAX)
        if cut <= 0:
            cut = TG_MAX
        yield text[:cut]
        text = text[cut:].lstrip("\n")
    yield text


# --------------------------------------------------------------------------- #
# Telegram handlers
# --------------------------------------------------------------------------- #

async def deliver(context, chat_id, kind, text):
    """Send a turn to the chat, attaching the keyboard to the last chunk."""
    context.chat_data["last_kind"] = kind
    lang = context.chat_data.get("lang", "en")
    body, keyboard = render(kind, text, lang)
    pieces = list(chunks(body)) if body.strip() else []
    if not pieces and keyboard is not None:
        pieces = ["…"]  # Telegram rejects empty text; keep the keyboard reachable
    for i, piece in enumerate(pieces):
        last = (i == len(pieces) - 1)
        await context.bot.send_message(
            chat_id=chat_id,
            text=piece,
            reply_markup=keyboard if last else None,
        )
    if kind == "final":
        await context.bot.send_message(
            chat_id=chat_id,
            text="Session closed. Send /start for a new consultation. 👋",
        )


async def start_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat_id = update.effective_chat.id
    bridge: PrologBridge = context.application.bot_data["bridge"]
    context.chat_data["history"] = []
    await update.message.reply_markdown(DISCLAIMER)
    try:
        kind, text = await bridge.turn_start(str(chat_id))
    except Exception:
        logger.exception("bot_start failed")
        await update.message.reply_text("⚠️ Engine error on start. Try again.")
        return
    await deliver(context, chat_id, kind, text)


async def cancel_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat_id = update.effective_chat.id
    bridge: PrologBridge = context.application.bot_data["bridge"]
    context.chat_data["history"] = []
    await bridge.cancel(str(chat_id))
    await update.message.reply_text("Consultation cancelled. Send /start to begin again.")


async def push_answer(update: Update, context: ContextTypes.DEFAULT_TYPE, raw: str):
    """Forward an answer to the engine, or, for '◀️ back', undo the last answer.

    Going back is implemented by deterministic replay: restart the session and
    re-feed every recorded answer except the last one, which lands the engine
    back on the previous question. 'why' answers are not recorded because they
    only print an explanation and leave the working memory unchanged."""
    chat_id = update.effective_chat.id
    bridge: PrologBridge = context.application.bot_data["bridge"]
    sid = str(chat_id)
    history = context.chat_data.setdefault("history", [])

    if raw == "back":
        if not history:
            await context.bot.send_message(
                chat_id, "You are already at the first question. / Sei già alla prima domanda.")
            return
        history.pop()
        try:
            kind, text = await bridge.turn_start(sid)
            for past in history:
                kind, text = await bridge.turn_answer(sid, past)
        except Exception:
            logger.exception("back replay failed")
            await context.bot.send_message(chat_id, "⚠️ Engine error. Send /start to restart.")
            return
        await deliver(context, chat_id, kind, text)
        return

    # Remember the chosen interface language (the answer to the first turn) so
    # the bot-side helper texts match it.
    if context.chat_data.get("last_kind") == "language":
        context.chat_data["lang"] = "it" if raw in ("2", "it") else "en"

    try:
        kind, text = await bridge.turn_answer(sid, raw)
    except Exception:
        logger.exception("bot_answer failed")
        await context.bot.send_message(chat_id, "⚠️ Engine error. Send /start to restart.")
        return

    if raw != "why":
        history.append(raw)
    if kind == "final":
        context.chat_data["history"] = []
    await deliver(context, chat_id, kind, text)


async def on_callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    query = update.callback_query
    await query.answer()
    await push_answer(update, context, query.data)


async def on_text(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await push_answer(update, context, update.message.text.strip())


# --------------------------------------------------------------------------- #
# Lifecycle
# --------------------------------------------------------------------------- #

async def post_init(application: Application):
    bridge = PrologBridge()
    await bridge.start()
    application.bot_data["bridge"] = bridge


async def post_shutdown(application: Application):
    bridge = application.bot_data.get("bridge")
    if bridge:
        await bridge.stop()


def load_env_file():
    """Load KEY=VALUE pairs from a .env next to this script (no extra deps)."""
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env")
    if not os.path.exists(path):
        return
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, _, value = line.partition("=")
            os.environ.setdefault(key.strip(), value.strip().strip('"').strip("'"))


def main():
    load_env_file()
    token = os.environ.get("TELEGRAM_TOKEN") or os.environ.get("TOKEN")
    if not token:
        raise SystemExit("Set the bot token in TELEGRAM_TOKEN (or TOKEN), or telegram_bot/.env.")

    app = (
        Application.builder()
        .token(token)
        .post_init(post_init)
        .post_shutdown(post_shutdown)
        .build()
    )

    app.add_handler(CommandHandler(["start", "new"], start_cmd))
    app.add_handler(CommandHandler("cancel", cancel_cmd))
    app.add_handler(CallbackQueryHandler(on_callback))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, on_text))

    # Python 3.12+ no longer auto-creates an event loop in the main thread, but
    # python-telegram-bot's run_polling() still calls asyncio.get_event_loop().
    try:
        asyncio.get_event_loop()
    except RuntimeError:
        asyncio.set_event_loop(asyncio.new_event_loop())

    logger.info("PESAD bot starting (polling)…")
    app.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == "__main__":
    main()
