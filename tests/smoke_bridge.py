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

from pesad_bot import Engine, render  # noqa: E402


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
    finally:
        await engine.stop()
    print("smoke_bridge: OK")


if __name__ == "__main__":
    asyncio.run(main())
