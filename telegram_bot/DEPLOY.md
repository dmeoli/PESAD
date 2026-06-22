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

CI builds and publishes the image to **`ghcr.io/dmeoli/pesad:latest`** on every
push to `master`, so the recommended path is to **pull that image with Docker**
on the VM — no clone, no build. A from-source systemd path is also provided.

## Option A — Docker from GHCR (recommended)

**One-time:** make the package public so the VM can pull without logging in —
GitHub → your profile → **Packages** → **pesad** → **Package settings** →
**Change visibility** → **Public**. (Or, to keep it private, run
`docker login ghcr.io -u dmeoli` with a PAT that has `read:packages` on the VM.)

**From your machine** (uses the SSH key for the VM):

```bash
make deploy VM=ubuntu@<VM_IP> TOKEN=<TELEGRAM_TOKEN>   # first time
make logs   VM=ubuntu@<VM_IP>                          # follow logs
# later, to update to the latest image (token already saved):
make deploy VM=ubuntu@<VM_IP>
```

**Or directly on the VM:**

```bash
command -v docker >/dev/null || curl -fsSL https://get.docker.com | sudo sh
sudo mkdir -p /opt/pesad && cd /opt/pesad
curl -fsSL https://raw.githubusercontent.com/dmeoli/PESAD/master/docker-compose.yml \
  | sudo tee docker-compose.yml >/dev/null
echo "TELEGRAM_TOKEN=<TELEGRAM_TOKEN>" | sudo tee .env >/dev/null
sudo docker compose pull && sudo docker compose up -d
sudo docker compose logs -f       # check it started
```

`restart: unless-stopped` keeps it alive across crashes and reboots; updating is
`docker compose pull && docker compose up -d`.

## Option B — systemd from source (no Docker, no public image)

SSH into the VM, then run (token as argument):

```bash
curl -fsSL https://raw.githubusercontent.com/dmeoli/PESAD/master/telegram_bot/setup.sh \
  | sudo bash -s -- <TELEGRAM_TOKEN>
```

It installs SWI-Prolog (with `library(mqi)`) + Python, clones the repo to
`/opt/PESAD`, creates the virtualenv, writes `.env`, and installs and starts the
`pesad-bot` systemd service (always-on, auto-restart). Re-running it pulls the
latest code and restarts. Follow logs with `journalctl -u pesad-bot -f`.

## Scaling note

The bridge uses a single MQI connection serialised by a lock; the heavy
inference runs in per-chat Prolog worker threads, so a handful of concurrent
users is fine. For many concurrent users, switch to a pool of MQI connections
(one `create_thread()` per in-flight request).
