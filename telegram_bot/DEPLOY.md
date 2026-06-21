# Deploying the PESAD bot always-on

The bot needs a **long-running process** (Telegram long-polling) and the native
**SWI-Prolog** engine, so it must run on something that stays awake. Free PaaS
tiers that *sleep* on inactivity (Render free, Railway trial credits, Replit
free) are **not** suitable — the polling process gets killed. Heroku no longer
has a free tier.

## Where (free, always-on)

| Option | Free? | Notes |
| --- | --- | --- |
| **Oracle Cloud "Always Free" VM** ⭐ | perpetual | Real VM (ARM Ampere up to 4 OCPU / 24 GB). Best free always-on. Account setup needs a card for verification. |
| **Google Cloud `e2-micro`** | perpetual (1/mo, US regions) | Small always-free VM. Same approach as Oracle. |
| **Fly.io** | small free allowance | Easiest (deploys the Dockerfile). Requires a card; usage beyond the allowance is billed. |

On a **VM** you can run the bot either with Docker (below) or directly with the
provided **systemd** unit. On **Fly.io** you deploy the Dockerfile.

## Option A — Docker (any VM, or Fly.io)

From the repository root:

```bash
export TELEGRAM_TOKEN="123456789:your-bot-token"   # or put it in a .env file
docker compose up -d --build
docker compose logs -f          # check it started
```

`restart: unless-stopped` keeps it alive across crashes and reboots.

## Option B — systemd (VM, no Docker)

```bash
# on the VM, as root-ish:
sudo apt update && sudo apt install -y swi-prolog python3 python3-venv git
sudo git clone https://github.com/dmeoli/PESAD.git /opt/PESAD
cd /opt/PESAD/telegram_bot
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
printf 'TELEGRAM_TOKEN=123456789:your-bot-token\n' > .env

sudo cp pesad-bot.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now pesad-bot
sudo systemctl status pesad-bot          # check
journalctl -u pesad-bot -f               # logs
```

Edit the paths in `pesad-bot.service` if you clone somewhere other than
`/opt/PESAD`. Ensure SWI-Prolog ships `library(mqi)`:
`swipl -g "use_module(library(mqi)),halt"`.

## Scaling note

The bridge uses a single MQI connection serialised by a lock; the heavy
inference runs in per-chat Prolog worker threads, so a handful of concurrent
users is fine. For many concurrent users, switch to a pool of MQI connections
(one `create_thread()` per in-flight request).
