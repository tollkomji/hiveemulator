#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script as root on the VPS." >&2
  exit 1
fi

STUDENT_USER="${STUDENT_USER:-}"
if [[ -z "${STUDENT_USER}" ]]; then
  echo "Set STUDENT_USER, for example: STUDENT_USER=kpi_io36_bilostennyi ./bootstrap-server.sh" >&2
  exit 1
fi

if ! id "${STUDENT_USER}" >/dev/null 2>&1; then
  adduser --disabled-password --gecos "" "${STUDENT_USER}"
  usermod -aG sudo "${STUDENT_USER}"
fi

if [[ -d /root/.ssh ]]; then
  rsync --archive --chown="${STUDENT_USER}:${STUDENT_USER}" /root/.ssh "/home/${STUDENT_USER}"
fi

apt-get update
apt-get install -y ca-certificates curl gnupg unzip wget sudo rsync ufw nginx redis-server

if ! command -v dotnet >/dev/null 2>&1; then
  . /etc/os-release
  wget "https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb
  dpkg -i /tmp/packages-microsoft-prod.deb
  rm /tmp/packages-microsoft-prod.deb
  apt-get update
  apt-get install -y aspnetcore-runtime-8.0
fi

systemctl enable --now redis-server
systemctl enable --now nginx

ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 8080/tcp
ufw allow 5149/tcp
ufw --force enable

mkdir -p /tmp/lab1-systemd /tmp/lab1-nginx
cat >/tmp/lab1-systemd/communication-control.service <<'SERVICE'
[Unit]
Description=Hive Emulator Communication Control API
After=network.target redis-server.service
Wants=redis-server.service

[Service]
User=<STUDENT_USER>
WorkingDirectory=/home/<STUDENT_USER>/app/communication-control
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=Redis__ConnectionString=localhost:6379
Environment=Urls=http://0.0.0.0:8080
ExecStart=/usr/bin/dotnet /home/<STUDENT_USER>/app/communication-control/DevOpsProject.CommunicationControl.API.dll
Restart=always
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=hive-communication-control

[Install]
WantedBy=multi-user.target
SERVICE

cat >/tmp/lab1-systemd/hive-mind.service <<'SERVICE'
[Unit]
Description=Hive Emulator HiveMind API
After=network.target communication-control.service
Wants=communication-control.service

[Service]
User=<STUDENT_USER>
WorkingDirectory=/home/<STUDENT_USER>/app/hive-mind
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=Urls=http://0.0.0.0:5149
Environment=CommunicationConfiguration__RequestSchema=http
Environment=CommunicationConfiguration__CommunicationControlIP=localhost
Environment=CommunicationConfiguration__CommunicationControlPort=8080
Environment=CommunicationConfiguration__CommunicationControlPath=api/v1/hive
Environment=CommunicationConfiguration__HiveIP=localhost
Environment=CommunicationConfiguration__HivePort=5149
ExecStart=/usr/bin/dotnet /home/<STUDENT_USER>/app/hive-mind/DevOpsProject.HiveMind.API.dll
Restart=always
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=hive-mind

[Install]
WantedBy=multi-user.target
SERVICE

cat >/tmp/lab1-nginx/hive-map.conf <<'NGINX'
server {
    listen 80;
    server_name _;

    root /var/www/hive-map;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location = /config.json {
        add_header Cache-Control "no-store";
        try_files /config.json =404;
    }
}
NGINX

echo "Bootstrap complete."
echo "Next: upload ZIP artifacts, install them, then copy templates from /tmp/lab1-systemd and /tmp/lab1-nginx."
