# PESAD Telegram bot

A Telegram front-end for the [PESAD](../README.md) Prolog expert system, so the
DSM-5-TR consultation can be run from a chat instead of the terminal — **without
rewriting the inference engine**.

## How it works

PESAD's engine is a *synchronous, blocking* Prolog REPL: questions are asked with
`read/1` in the middle of the proof search. A Telegram bot, on the contrary, is
asynchronous. The bridge between the two is built entirely on standard
SWI-Prolog facilities:

- **One worker thread per chat.** Each consultation runs the ordinary `main/0`
  in its own thread. The session-state predicates (`known/4`, `fact/8`,
  `rule_I/II/III`, the `last_level_*` indexes, `language/1`,
  `uncertainty_method/1`) are declared `thread_local` in
  [`../bot_boot.pl`](../bot_boot.pl), so concurrent chats are fully isolated.
  The knowledge base (`disorders.pl`, `criteria.pl`, the locales) stays shared
  and read-only.
- **Suspend/resume via message queues.** Every interactive `read/1` in the
  engine was replaced by `ui_read(Kind, Term)` (see
  [`../bot_io.pl`](../bot_io.pl)). In bot mode it flushes the captured console
  output as a *turn* and blocks the worker on an input queue until the next
  answer arrives. `Kind` (`language | method | command | simple | criterion |
  certainty | menu | menu_why | number | final`) tells the front-end which
  keyboard to render. In terminal mode `ui_read` is just `read/1`, so
  `swipl start.pl` keeps working exactly as before.
- **MQI transport.** Python drives Prolog over the Machine Query Interface
  (`library(mqi)` ⇄ the `swiplserver` package) with three predicates from
  [`../bot_session.pl`](../bot_session.pl): `bot_start/3`, `bot_answer/4`,
  `bot_cancel/1`.

```
Telegram  ──polling──►  pesad_bot.py  ──MQI──►  bot_session.pl
                                                   │  (per-chat worker thread)
                                                   ▼
                                  main/0 → ui_read/2 ⇄ message queues
```

## Prerequisites

- SWI-Prolog ≥ 8.4 with `library(mqi)` (bundled; verify with
  `swipl -g "use_module(library(mqi)),halt"`).
- Python ≥ 3.9.
- A Telegram bot token from [@BotFather](https://t.me/BotFather).

## Setup

```bash
cd telegram_bot
uv venv .venv                                   # or: python3 -m venv .venv
uv pip install --python .venv/bin/python -r requirements.txt
```

(If you don't use `uv`: `.venv/bin/pip install -r requirements.txt`.)

## Run (local, long-polling)

Put your [@BotFather](https://t.me/BotFather) token in `telegram_bot/.env`
(git-ignored):

```
TELEGRAM_TOKEN=123456789:your-bot-token
```

then start the bot:

```bash
.venv/bin/python pesad_bot.py
```

(`TELEGRAM_TOKEN` / `TOKEN` set in the environment also work and take
precedence over `.env`.) Then open the bot in Telegram and send **/start**.

### Commands

| Command   | Effect                                            |
| --------- | ------------------------------------------------- |
| `/start`  | Show the disclaimer and begin a new consultation  |
| `/new`    | Restart the consultation                          |
| `/cancel` | Abort the current consultation                    |

Answers are given by tapping inline buttons (yes/no/why, numbered menus,
certainty presets, the command menu). For graded values (`number` turns) just
type a number and send it.

A **◀️ back / indietro** button is shown on every prompt (except the first
language choice). Since the engine has no native undo, "back" is implemented by
*deterministic replay*: the session is restarted and every recorded answer
except the last is re-fed, landing the engine back on the previous question.
`why` requests are not recorded (they only print an explanation and leave the
working memory unchanged), so backing over them behaves naturally.

Explanations are available too: **❓ why / perché** while answering shows the
rationale of the current criterion, and answering *yes* to "how was it deduced?"
after a diagnosis prints the full proof tree.

## Notes & limits

- ⚠️ PESAD is an academic system over the DSM-5-TR criteria; it is **not** a
  medical device and does not replace a professional. The bot shows this
  disclaimer on every `/start`.
- The bridge uses a single MQI connection serialised by an `asyncio.Lock`. The
  heavy inference runs in the per-chat Prolog worker threads, so a few
  simultaneous users are fine for a local deployment. To scale to many
  concurrent users, switch to a pool of MQI connections (one
  `create_thread()` per in-flight request).
- Deployment here targets **local long-polling**. For a server, wrap
  `app.run_webhook(...)` behind an HTTPS reverse proxy instead of
  `run_polling()`.
