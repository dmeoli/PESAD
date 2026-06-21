#!/usr/bin/env python3
"""Smoke test for the PESAD bot bridge.

Drives a short consultation through the Prolog engine over the MQI bridge
(no Telegram token needed): it exercises bot_start/bot_answer, the per-chat
worker thread and the turn rendering. Exits non-zero on any mismatch so it can
gate CI.
"""

import asyncio
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "telegram_bot"))

from pesad_bot import PrologBridge, render  # noqa: E402


async def main():
    bridge = PrologBridge()
    await bridge.start()
    try:
        kind, _ = await bridge.turn_start("ci")
        assert kind == "language", f"expected language, got {kind!r}"

        kind, _ = await bridge.turn_answer("ci", "1")          # English
        assert kind == "method", f"expected method, got {kind!r}"

        kind, _ = await bridge.turn_answer("ci", "1")          # certainty factors
        assert kind == "command", f"expected command, got {kind!r}"

        kind, _ = await bridge.turn_answer("ci", "control")    # single-disorder check
        assert kind == "menu", f"expected menu, got {kind!r}"

        kind, text = await bridge.turn_answer("ci", "1")       # first disorder
        assert kind in ("menu_why", "criterion"), f"unexpected first question {kind!r}"

        body, keyboard = render(kind, text, "en")
        assert body, "empty rendered body"
        assert keyboard is not None, "missing keyboard on a question turn"

        await bridge.cancel("ci")
    finally:
        await bridge.stop()
    print("smoke_bridge: OK")


if __name__ == "__main__":
    asyncio.run(main())
