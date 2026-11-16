#!/usr/bin/env python3
# coding=utf-8

"""
PESAD Telegram bot.

Front-end that makes the PESAD Prolog expert system (a blocking terminal REPL)
available as a Telegram bot, without rewriting the inference engine.

How it works
------------
The engine is reached through the engine layer (../pesad_engine), shared with
the web API, which drives SWI-Prolog over the Machine Query Interface. On the
Prolog side (see ../prolog/bot_boot.pl and ../prolog/bot_session.pl) every chat
owns a dedicated worker thread that runs the usual `main/0` consultation; each
interactive `read/1` was replaced by `ui_read/2`, which suspends the worker on a
message queue until the next answer arrives.

So the bot only ever exchanges *turns* (engine screens) with Prolog:
  - engine.open(chat)            -> first turn of a new consultation
  - engine.answer(chat, raw)     -> deliver an answer, get next turn
  - engine.replay(chat, raws)    -> restart and re-feed answers (back button)
  - engine.cancel(chat)          -> abort a consultation

`kind` tells us which keyboard to render; `text` is the captured console output
to display. `kind == 'final'` means the consultation ended (text is its epilogue).

Author: Donato Meoli
"""

import asyncio
import logging
import os
import re
import sys

from telegram import (Update, InlineKeyboardButton, InlineKeyboardMarkup,
                      constants)
from telegram.ext import (Application, CommandHandler, CallbackQueryHandler,
                          MessageHandler, ContextTypes, filters)

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO,
)
logger = logging.getLogger("pesad-bot")
# httpx logs every request URL at INFO, and the Bot API URL holds the token.
logging.getLogger("httpx").setLevel(logging.WARNING)
logging.getLogger("httpcore").setLevel(logging.WARNING)

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from pesad_engine import CERTAINTY_VALUES, Engine  # noqa: E402

# --------------------------------------------------------------------------- #
# Paths / configuration
# --------------------------------------------------------------------------- #

TG_MAX = constants.MessageLimit.MAX_TEXT_LENGTH  # 4096

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
# The certainty question is normally answered behind the scenes (see STEPS).
CERTAINTIES = [(value, value) for value in CERTAINTY_VALUES]

# One "how true is it?" question replaces the yes/no question of a criterion
# and its certainty question, as on the site: each step is the pair of
# answers it stands for.
STEPS = [
    ({"en": "not at all", "it": "per niente"}, "no", "1.0"),
    ({"en": "a little", "it": "poco"}, "yes", "0.25"),
    ({"en": "partly", "it": "in parte"}, "yes", "0.5"),
    ({"en": "mostly", "it": "abbastanza"}, "yes", "0.75"),
    ({"en": "completely", "it": "del tutto"}, "yes", "1.0"),
]
HOW_TRUE = {"en": "How true is it?", "it": "Quanto è vero?"}
YES_NO_HINT = re.compile(r"\?\s*\((yes, no|si, no)\)\s*$", re.MULTILINE)

# The uncertainty methods (the answers 1-6 of the method question): a short
# label for the button and a one-line explanation.
METHODS = [
    ({"en": "Cautious (certainty factors)", "it": "Prudente (fattori di certezza)"},
     {"en": "the weakest answer decides; recommended",
      "it": "decide la risposta più debole; consigliato"}),
    ({"en": "Soft (fuzzy product)", "it": "Morbido (fuzzy prodotto)"},
     {"en": "the doubts multiply", "it": "i dubbi si moltiplicano"}),
    ({"en": "Graded (membership functions)", "it": "Graduale (funzioni di appartenenza)"},
     {"en": "asks durations and counts as numbers and grades them",
      "it": "chiede durate e conteggi come numeri e li sfuma"}),
    ({"en": "Strict (Lukasiewicz)", "it": "Severo (Lukasiewicz)"},
     {"en": "small doubts on several answers add up to zero",
      "it": "piccoli dubbi su più risposte si sommano fino a zero"}),
    ({"en": "Balanced (Hamacher)", "it": "Equilibrato (Hamacher)"},
     {"en": "between the cautious and the soft one",
      "it": "fra il prudente e il morbido"}),
    ({"en": "Moderate (Einstein)", "it": "Moderato (Einstein)"},
     {"en": "a little stricter than the soft one",
      "it": "un po' più severo del morbido"}),
]
METHOD_INTRO = {"en": "How should the uncertainty of the answers be combined?",
                "it": "Come combinare l'incertezza delle risposte?"}
METHOD_HINT = {"en": "If unsure, pick the first.", "it": "Nel dubbio scegli il primo."}

HELP = {
    "en": ("PESAD asks about symptoms, one at a time, and ranks the disorders "
           "of the DSM-5-TR they support.\n"
           "• answer with the buttons: for a symptom, how true it is, from "
           "\"not at all\" to \"completely\";\n"
           "• ❓ why explains what a question is for;\n"
           "• ◀️ back undoes the last answer;\n"
           "• /start begins a new consultation, /cancel stops it."),
    "it": ("PESAD chiede i sintomi uno alla volta e ordina i disturbi del "
           "DSM-5-TR che le risposte sostengono.\n"
           "• rispondi con i pulsanti: per un sintomo, quanto è vero, da "
           "\"per niente\" a \"del tutto\";\n"
           "• ❓ perché spiega a cosa serve una domanda;\n"
           "• ◀️ indietro annulla l'ultima risposta;\n"
           "• /start inizia una nuova consultazione, /cancel la interrompe."),
}

OPTION_RE = re.compile(r"^[ \t]*(\d+):[ \t]*(.+?)[ \t]*$", re.MULTILINE)


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


def method_screen(lang):
    """The method question: one button per method, a line of explanation each."""
    lines = [METHOD_INTRO[lang]]
    rows = []
    for number, (label, explanation) in enumerate(METHODS, start=1):
        lines.append(f"{number} · {label[lang]}: {explanation[lang]}")
        mark = "  ✅" if number == 1 else ""
        rows.append([InlineKeyboardButton(f"{number}. {label[lang]}{mark}",
                                          callback_data=str(number))])
    lines.append(METHOD_HINT[lang])
    return "\n".join(lines), rows


def render(kind, text, lang="en", topic=None):
    """Return (display_text, InlineKeyboardMarkup|None) for a turn.

    A criterion is asked as one "how true is it?" question with five steps
    (STEPS), which push_answer turns into the yes/no answer and its certainty.
    A '◀️ back' button is appended to every prompt except the first one
    (language selection); tapping it replays the consultation up to the
    previous answer (see push_answer)."""
    lang = lang if lang in ("en", "it") else "en"
    if kind == "method":
        body, rows = method_screen(lang)
    elif kind in ("language", "menu", "menu_why"):
        body = strip_prompts(OPTION_RE.sub("", text))
        keyboard = numbered_keyboard(text, add_why=(kind == "menu_why"))
        rows = [list(r) for r in keyboard.inline_keyboard] if keyboard else []
    elif kind == "command":
        rows = [[InlineKeyboardButton(lbl, callback_data=cmd)]
                for lbl, cmd in COMMANDS]
        body = clean_command_body(text) or "Choose a command / Scegli un comando:"
    elif kind == "simple":
        rows = [[InlineKeyboardButton("✅ yes / sì", callback_data="yes"),
                 InlineKeyboardButton("❌ no", callback_data="no")]]
        body = strip_prompts(text)
    elif kind == "criterion":
        rows = [[InlineKeyboardButton(label[lang], callback_data=f"t:{i}")
                 for i, (label, _, _) in enumerate(STEPS)],
                [InlineKeyboardButton("❓ why / perché", callback_data="why")]]
        question = YES_NO_HINT.sub("?", strip_prompts(text)).rstrip()
        body = f"{question}\n\n{HOW_TRUE[lang]}"
    elif kind == "certainty":
        rows = [[InlineKeyboardButton(lbl, callback_data=val)
                 for lbl, val in CERTAINTIES]]
        body = strip_prompts(text)
    elif kind == "number":
        values = [o["value"] for o in (topic or {}).get("options", [])]
        rows = [[InlineKeyboardButton(v, callback_data=f"n:{v}") for v in values[i:i + 6]]
                for i in range(0, len(values), 6)]
        hint = ("⌨️ Scegli un valore o scrivi un altro numero." if lang == "it"
                else "⌨️ Pick a value or type another number.")
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

async def deliver(context, chat_id, screen):
    """Send a turn to the chat, attaching the keyboard to the last chunk."""
    kind, text = screen.kind, screen.text
    context.chat_data["last_kind"] = kind
    lang = context.chat_data.get("lang", "en")
    body, keyboard = render(kind, text, lang, screen.topic)
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
    engine: Engine = context.application.bot_data["engine"]
    context.chat_data["history"] = []
    await update.message.reply_markdown(context.application.bot_data["disclaimer"])
    try:
        screen = await engine.open(str(chat_id))
    except Exception:
        logger.exception("engine.open failed")
        await update.message.reply_text("⚠️ Engine error on start. Try again.")
        return
    await deliver(context, chat_id, screen)


async def help_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(HELP[context.chat_data.get("lang", "en")])


async def cancel_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat_id = update.effective_chat.id
    engine: Engine = context.application.bot_data["engine"]
    context.chat_data["history"] = []
    await engine.cancel(str(chat_id))
    await update.message.reply_text("Consultation cancelled. Send /start to begin again.")


def expand(raw):
    """The engine answers a button stands for: a step of "how true is it?"
    is the yes/no answer and its certainty, a graded value is its number."""
    if raw.startswith("t:") and raw[2:].isdigit() and int(raw[2:]) < len(STEPS):
        _, answer, certainty = STEPS[int(raw[2:])]
        return [answer, certainty]
    if raw.startswith("n:"):
        return [raw[2:]]
    return [raw]


async def answer_turn(engine, sid, raw):
    """Deliver the answer `raw` and return (screen, raws): the next screen to
    show and the engine answers sent. The certainty question that follows a
    step or a multiple choice is answered here and never shown: with the
    certainty of the step, or 1.0 for a choice."""
    raws = expand(raw)
    screen = await engine.answer(sid, raws[0])
    if screen.kind == "certainty" and raw != "why":
        certainty = raws[1] if len(raws) > 1 else "1.0"
        raws = [raws[0], certainty]
        screen = await engine.answer(sid, certainty)
    return screen, raws[:1] if raw == "why" else raws


async def push_answer(update: Update, context: ContextTypes.DEFAULT_TYPE, raw: str):
    """Forward an answer to the engine, or, for '◀️ back', undo the last answer.

    Going back is implemented by deterministic replay: restart the session and
    re-feed every recorded answer except the last one, which lands the engine
    back on the previous question. Every entry of the history holds the
    engine answers of one button (a step is two: the answer and its
    certainty), so back removes them together. 'why' answers are not
    recorded because they only print an explanation and leave the working
    memory unchanged."""
    chat_id = update.effective_chat.id
    engine: Engine = context.application.bot_data["engine"]
    sid = str(chat_id)
    history = context.chat_data.setdefault("history", [])

    if raw == "back":
        if not history:
            await context.bot.send_message(
                chat_id, "You are already at the first question. / Sei già alla prima domanda.")
            return
        history.pop()
        try:
            screen = await engine.replay(sid, [r for group in history for r in group])
        except Exception:
            logger.exception("back replay failed")
            await context.bot.send_message(chat_id, "⚠️ Engine error. Send /start to restart.")
            return
        await deliver(context, chat_id, screen)
        return

    # Remember the chosen interface language (the answer to the first turn) so
    # the bot-side helper texts match it.
    if context.chat_data.get("last_kind") == "language":
        context.chat_data["lang"] = "it" if raw in ("2", "it") else "en"

    try:
        screen, raws = await answer_turn(engine, sid, raw)
    except Exception:
        logger.exception("engine.answer failed")
        await context.bot.send_message(chat_id, "⚠️ Engine error. Send /start to restart.")
        return

    if raw != "why":
        history.append(raws)
    if screen.kind == "final":
        context.chat_data["history"] = []
    await deliver(context, chat_id, screen)


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
    engine = Engine()
    await engine.start()
    logger.info("Prolog engine loaded")
    application.bot_data["engine"] = engine
    # The disclaimer comes from the locales, in both languages (the language
    # is chosen only after it is shown).
    en = await engine.label("en", "disclaimer")
    it = await engine.label("it", "disclaimer")
    application.bot_data["disclaimer"] = f"⚠️ {en}\n_{it}_"


async def post_shutdown(application: Application):
    engine = application.bot_data.get("engine")
    if engine:
        await engine.stop()


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
    app.add_handler(CommandHandler("help", help_cmd))
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
