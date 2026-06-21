# PESAD Telegram bot — SWI-Prolog engine + Python (python-telegram-bot) front-end.
# Based on the official SWI-Prolog image (ships library(mqi)); Python is added on top.
FROM swipl:9

RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-venv \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Isolated virtualenv for the bot dependencies.
RUN python3 -m venv /app/.venv \
 && /app/.venv/bin/pip install --no-cache-dir -r telegram_bot/requirements.txt

# The token is provided at run time (env var or --env-file), never baked in.
ENV TELEGRAM_TOKEN=""

CMD ["/app/.venv/bin/python", "telegram_bot/pesad_bot.py"]
