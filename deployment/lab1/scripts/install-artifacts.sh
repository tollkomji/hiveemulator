#!/usr/bin/env bash
set -euo pipefail

STUDENT_USER="${STUDENT_USER:-$(whoami)}"
HOME_DIR="/home/${STUDENT_USER}"

if [[ "$(whoami)" != "${STUDENT_USER}" ]]; then
  echo "Run this script as ${STUDENT_USER}, or set STUDENT_USER to the current user." >&2
  exit 1
fi

for file in communication-control-api.zip hive-mind-api.zip map-client.zip; do
  if [[ ! -f "${HOME_DIR}/${file}" ]]; then
    echo "Missing ${HOME_DIR}/${file}" >&2
    exit 1
  fi
done

if [[ ! -f /tmp/lab1-systemd/communication-control.service || ! -f /tmp/lab1-systemd/hive-mind.service ]]; then
  echo "Missing /tmp/lab1-systemd templates. Run bootstrap-server.sh as root first." >&2
  exit 1
fi

if [[ ! -f /tmp/lab1-nginx/hive-map.conf ]]; then
  echo "Missing /tmp/lab1-nginx template. Run bootstrap-server.sh as root first." >&2
  exit 1
fi

mkdir -p "${HOME_DIR}/app/communication-control" "${HOME_DIR}/app/hive-mind" "${HOME_DIR}/map-client"
unzip -oq "${HOME_DIR}/communication-control-api.zip" -d "${HOME_DIR}/app/communication-control"
unzip -oq "${HOME_DIR}/hive-mind-api.zip" -d "${HOME_DIR}/app/hive-mind"
unzip -oq "${HOME_DIR}/map-client.zip" -d "${HOME_DIR}/map-client"

sudo cp /tmp/lab1-systemd/communication-control.service /etc/systemd/system/communication-control.service
sudo cp /tmp/lab1-systemd/hive-mind.service /etc/systemd/system/hive-mind.service
sudo sed -i "s|<STUDENT_USER>|${STUDENT_USER}|g" /etc/systemd/system/communication-control.service
sudo sed -i "s|<STUDENT_USER>|${STUDENT_USER}|g" /etc/systemd/system/hive-mind.service
sudo systemctl daemon-reload
sudo systemctl enable --now communication-control.service
sudo systemctl enable --now hive-mind.service

sudo mkdir -p /var/www/hive-map
sudo cp -r "${HOME_DIR}/map-client/." /var/www/hive-map/
sudo cp /tmp/lab1-nginx/hive-map.conf /etc/nginx/sites-available/hive-map.conf
sudo ln -sf /etc/nginx/sites-available/hive-map.conf /etc/nginx/sites-enabled/hive-map.conf
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx

echo "Lab 1 artifacts installed."
echo "Open: http://<SERVER_IP>/"
