#!/usr/bin/env bash
# Copyright (c) 2021-2025 community-scripts ORG
# Author: tuo-nome
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installazione delle dipendenze di sistema"
# Installiamo preventivamente i pacchetti richiesti da Hermes per evitare prompt interattivi
$STD apt-get install -y curl sudo mc git ripgrep ffmpeg build-essential python3-dev libffi-dev
msg_ok "Dipendenze di sistema installate"

msg_info "Installazione di Hermes Agent (tramite script ufficiale)"
# Eseguiamo lo script ufficiale passando --skip-setup per l'automazione
$STD bash -c "$(curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh)" -- --skip-setup
msg_ok "Hermes Agent installato"

motd_ssh
customize

msg_info "Pulizia del sistema"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Pulizia completata"