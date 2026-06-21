#!/usr/bin/env bash
#
# setup.sh — provision the PESAD Telegram bot on an Ubuntu/Debian VM
# (e.g. Oracle Cloud "Always Free") as an always-on systemd service in
# long-polling mode. Idempotent: safe to re-run to update an existing install.
#
# Usage on the VM (token as argument or it will be asked):
#   sudo bash setup.sh [TELEGRAM_TOKEN]
#
# Or bootstrap in a single line (token MUST be passed, no prompt when piped):
#   curl -fsSL https://raw.githubusercontent.com/dmeoli/PESAD/master/telegram_bot/setup.sh \
#     | sudo bash -s -- <TELEGRAM_TOKEN>
#
set -euo pipefail

REPO_URL="https://github.com/dmeoli/PESAD.git"
INSTALL_DIR="/opt/PESAD"
SERVICE="pesad-bot"

if [ "$(id -u)" -ne 0 ]; then
	echo "This script needs root (apt/systemctl). Run: sudo bash setup.sh" >&2
	exit 1
fi
# Run the bot as the invoking (non-root) user when possible.
RUN_USER="${SUDO_USER:-root}"

echo "==> Installing system packages"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y --no-install-recommends swi-prolog python3 python3-venv git ca-certificates

echo "==> Checking SWI-Prolog library(mqi)"
if ! swipl -q -g "use_module(library(mqi)), halt" -t "halt(1)" 2>/dev/null; then
	echo "    library(mqi) missing -> adding the SWI-Prolog stable PPA"
	apt-get install -y --no-install-recommends software-properties-common
	add-apt-repository -y ppa:swi-prolog/stable
	apt-get update -y
	apt-get install -y swi-prolog
	swipl -q -g "use_module(library(mqi)), halt" -t "halt(1)"
fi

echo "==> Fetching the repository into $INSTALL_DIR"
if [ -d "$INSTALL_DIR/.git" ]; then
	git -C "$INSTALL_DIR" pull --ff-only
else
	git clone "$REPO_URL" "$INSTALL_DIR"
fi
chown -R "$RUN_USER":"$RUN_USER" "$INSTALL_DIR"

BOT_DIR="$INSTALL_DIR/telegram_bot"

echo "==> Creating the Python virtualenv and installing dependencies"
sudo -u "$RUN_USER" python3 -m venv "$BOT_DIR/.venv"
sudo -u "$RUN_USER" "$BOT_DIR/.venv/bin/pip" install --quiet --upgrade pip
sudo -u "$RUN_USER" "$BOT_DIR/.venv/bin/pip" install --quiet -r "$BOT_DIR/requirements.txt"

echo "==> Configuring the bot token ($BOT_DIR/.env)"
TOKEN="${1:-${TELEGRAM_TOKEN:-}}"
if [ -z "$TOKEN" ] && [ -f "$BOT_DIR/.env" ] && grep -q '^TELEGRAM_TOKEN=' "$BOT_DIR/.env"; then
	echo "    keeping the existing token in $BOT_DIR/.env"
else
	if [ -z "$TOKEN" ]; then
		if [ -t 0 ]; then
			read -rp "    Enter your Telegram bot token: " TOKEN
		else
			echo "    No token given and stdin is not interactive." >&2
			echo "    Re-run as: sudo bash setup.sh <TELEGRAM_TOKEN>" >&2
			exit 1
		fi
	fi
	printf 'TELEGRAM_TOKEN=%s\n' "$TOKEN" > "$BOT_DIR/.env"
	chown "$RUN_USER":"$RUN_USER" "$BOT_DIR/.env"
	chmod 600 "$BOT_DIR/.env"
fi

echo "==> Installing the systemd service ($SERVICE)"
cat > "/etc/systemd/system/$SERVICE.service" <<UNIT
[Unit]
Description=PESAD Telegram bot
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$RUN_USER
WorkingDirectory=$BOT_DIR
EnvironmentFile=$BOT_DIR/.env
ExecStart=$BOT_DIR/.venv/bin/python $BOT_DIR/pesad_bot.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now "$SERVICE"
sleep 2
systemctl --no-pager --full status "$SERVICE" || true

echo
echo "==> Done. The bot is enabled and running."
echo "    Logs:    journalctl -u $SERVICE -f"
echo "    Restart: sudo systemctl restart $SERVICE"
echo "    Update:  sudo bash $BOT_DIR/setup.sh   (pulls latest & restarts)"
