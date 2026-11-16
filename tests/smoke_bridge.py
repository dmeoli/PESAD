#!/usr/bin/env python3
"""Smoke test for the PESAD bot bridge.

Drives a short consultation through the Prolog engine over the MQI bridge
(no Telegram token needed): it exercises the engine layer the bot goes through
(open/answer/replay/cancel), the per-chat worker thread and the turn rendering. Exits non-zero on any mismatch so it can
gate CI.
"""

import asyncio
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "telegram_bot"))

from pesad_bot import STEPS, Engine, answer_turn, render  # noqa: E402


async def main():
    engine = Engine()
    await engine.start()
    try:
        kind = (await engine.open("ci")).kind
        assert kind == "language", f"expected language, got {kind!r}"

        kind = (await engine.answer("ci", "1")).kind           # English
        assert kind == "method", f"expected method, got {kind!r}"

        kind = (await engine.answer("ci", "1")).kind           # certainty factors
        assert kind == "command", f"expected command, got {kind!r}"

        kind = (await engine.answer("ci", "control")).kind     # single-disorder check
        assert kind == "menu", f"expected menu, got {kind!r}"

        screen = await engine.answer("ci", "1")                # first disorder
        kind, text = screen.kind, screen.text
        assert kind in ("menu_why", "criterion"), f"unexpected first question {kind!r}"

        body, keyboard = render(kind, text, "en")
        assert body, "empty rendered body"
        assert keyboard is not None, "missing keyboard on a question turn"

        again = await engine.replay("ci", ["1", "1", "control", "1"])  # back button
        assert (again.kind, again.text) == (kind, text), "replay diverged"

        await engine.cancel("ci")

        # An investigation: a criterion is one "how true is it?" question; its
        # step also answers the certainty question, which is never shown.
        history = []
        screen = await engine.open("ci2")
        for raw in ("1", "1", "investigation"):
            screen, raws = await answer_turn(engine, "ci2", raw)
            history.append(raws)
        body, keyboard = render(screen.kind, screen.text, "en", screen.topic)
        assert screen.kind == "menu_why", screen.kind               # age band
        screen, raws = await answer_turn(engine, "ci2", "4")         # adult
        history.append(raws)
        assert screen.kind == "menu_why" and screen.topic["id"] == "area", screen.kind
        body, keyboard = render(screen.kind, screen.text, "en", screen.topic)
        numbered = [b.callback_data for row in keyboard.inline_keyboard for b in row]
        assert numbered[:5] == ["1", "2", "3", "4", "5"], numbered
        screen, raws = await answer_turn(engine, "ci2", "5")         # all areas
        history.append(raws)
        assert screen.kind == "criterion", screen.kind
        body, keyboard = render(screen.kind, screen.text, "it", screen.topic)
        labels = [b.text for b in keyboard.inline_keyboard[0]]
        assert labels == [label["it"] for label, _, _ in STEPS], labels
        assert body.endswith("Quanto è vero?") and "(si, no)" not in body, body
        first = screen.text
        screen, raws = await answer_turn(engine, "ci2", "t:3")       # mostly
        assert raws == ["yes", "0.75"], raws
        assert screen.kind == "criterion" and screen.text != first, screen.kind
        history.append(raws)
        screen, raws = await answer_turn(engine, "ci2", "why")
        assert raws == ["why"] and screen.kind == "criterion"
        # back removes the pair: the replay lands on the first criterion again
        history.pop()
        again = await engine.replay("ci2", [r for group in history for r in group])
        assert again.kind == "criterion" and again.text.strip().endswith(first.strip()[-40:]), again.text
        await engine.cancel("ci2")

        # graded values have buttons from graded_options
        screen = await engine.open("ci3")
        for raw in ("1", "3", "investigation", "4", "2,3"):  # typed areas
            screen, _ = await answer_turn(engine, "ci3", raw)
        while screen.kind == "criterion":
            screen, _ = await answer_turn(engine, "ci3", "t:0")
        assert screen.kind in ("number", "menu_why"), screen.kind
        if screen.kind == "number":
            body, keyboard = render(screen.kind, screen.text, "en", screen.topic)
            values = [b.callback_data for row in keyboard.inline_keyboard for b in row]
            assert "n:12" in values, values
        await engine.cancel("ci3")

        body, keyboard = render("method", "", "en")
        assert len(keyboard.inline_keyboard) == 7 and "recommended" in body
    finally:
        await engine.stop()
    print("smoke_bridge: OK")


if __name__ == "__main__":
    asyncio.run(main())
