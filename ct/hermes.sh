#!/usr/bin/env bash
# Copyright (c) 2021-2025 community-scripts ORG
# Author: tuo-nome
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/NousResearch/hermes-agent

# Import main orchestrator
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

# Application Configuration
APP="Hermes"
var_tags="ai;agent;llm"

# Container Resources
var_cpu="2"
var_ram="2048"
var_disk="15" # 15GB consigliati per ospitare Node, Python, e i browser di Playwright

# Container Type & OS
var_os="debian"
var_version="12"
var_unprivileged="1"

# Display header ASCII art
header_info "$APP"

# Process command-line arguments and load configuration
variables

# Setup ANSI color codes and formatting
color

# Initialize error handling
catch_errors

function update_script() {
  header_info

  check_container_storage
  check_container_resources

  if [[ ! -d /root/.hermes ]]; then
    msg_error "Nessuna installazione di ${APP} trovata!"
    exit
  fi

  msg_info "Aggiornamento di ${APP} Agent"

  # Assicuriamoci che il binario sia nel PATH
  export PATH="$HOME/.local/bin:$PATH"

  if command -v hermes &> /dev/null; then
    hermes update
    msg_ok "Aggiornamento di ${APP} completato"
  else
    msg_error "Comando 'hermes' non trovato. Impossibile aggiornare automaticamente."
  fi

  exit
}

# Start the container creation workflow
start

# Build the container with selected configuration
build_container

# Set container description/notes in Proxmox UI
description

# Display success message
msg_ok "Completed successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Per iniziare a chattare e configurare le API, entra nella console dell'LXC ed esegui:${CL}"
echo -e "${TAB}${BGN}source ~/.bashrc${CL}"
echo -e "${TAB}${BGN}hermes setup${CL}"