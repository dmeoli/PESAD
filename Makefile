# PESAD — common tasks. Run `make` (or `make help`) to list targets.
#
# Local targets need SWI-Prolog (run/test) and a Python venv (install/bot).
# Remote targets (deploy/logs/restart/stop) act on the VM over SSH and deploy
# the prebuilt image from GHCR with Docker; pass VM, e.g.
#   make deploy VM=ubuntu@1.2.3.4 TOKEN=123:abc

SHELL := /bin/bash
BOT_DIR := telegram_bot
VENV := $(BOT_DIR)/.venv
PY := $(VENV)/bin/python
COMPOSE_URL := https://raw.githubusercontent.com/dmeoli/PESAD/master/docker-compose.yml
REMOTE_DIR := /opt/pesad
VM ?=
TOKEN ?=

.DEFAULT_GOAL := help
.PHONY: help run test install bot deploy logs restart stop

help: ## Show this help
	@awk 'BEGIN{FS=":.*## "} /^[a-zA-Z_-]+:.*## /{printf "  \033[36m%-9s\033[0m %s\n",$$1,$$2}' $(MAKEFILE_LIST)

run: ## Run the expert system in the terminal (SWI-Prolog)
	swipl prolog/start.pl

test: ## Run the clinical regression suite
	swipl prolog/clinical_tests.pl

install: ## Create the local venv and install bot dependencies
	@if command -v uv >/dev/null 2>&1; then \
		uv venv $(VENV) && uv pip install --python $(PY) -r $(BOT_DIR)/requirements.txt; \
	else \
		python3 -m venv $(VENV) && $(PY) -m pip install -r $(BOT_DIR)/requirements.txt; \
	fi

bot: ## Run the Telegram bot locally (reads telegram_bot/.env)
	$(PY) $(BOT_DIR)/pesad_bot.py

deploy: ## Deploy the GHCR image on the VM with Docker. Usage: make deploy VM=ubuntu@IP [TOKEN=...]
	@test -n "$(VM)" || { echo "Set VM, e.g. make deploy VM=ubuntu@1.2.3.4 [TOKEN=...]"; exit 1; }
	ssh $(VM) 'set -e; \
		command -v docker >/dev/null 2>&1 || { curl -fsSL https://get.docker.com | sudo sh; }; \
		sudo mkdir -p $(REMOTE_DIR); \
		curl -fsSL $(COMPOSE_URL) | sudo tee $(REMOTE_DIR)/docker-compose.yml >/dev/null; \
		if [ -n "$(TOKEN)" ]; then echo "TELEGRAM_TOKEN=$(TOKEN)" | sudo tee $(REMOTE_DIR)/.env >/dev/null; sudo chmod 600 $(REMOTE_DIR)/.env; fi; \
		cd $(REMOTE_DIR) && sudo docker compose pull && sudo docker compose up -d && sudo docker compose ps'

logs: ## Tail the bot logs on the VM. Usage: make logs VM=ubuntu@IP
	@test -n "$(VM)" || { echo "Set VM, e.g. make logs VM=ubuntu@1.2.3.4"; exit 1; }
	ssh $(VM) 'cd $(REMOTE_DIR) && sudo docker compose logs -f'

restart: ## Restart the bot on the VM. Usage: make restart VM=ubuntu@IP
	@test -n "$(VM)" || { echo "Set VM, e.g. make restart VM=ubuntu@1.2.3.4"; exit 1; }
	ssh $(VM) 'cd $(REMOTE_DIR) && sudo docker compose restart && sudo docker compose ps'

stop: ## Stop the bot on the VM. Usage: make stop VM=ubuntu@IP
	@test -n "$(VM)" || { echo "Set VM, e.g. make stop VM=ubuntu@1.2.3.4"; exit 1; }
	ssh $(VM) 'cd $(REMOTE_DIR) && sudo docker compose down'
