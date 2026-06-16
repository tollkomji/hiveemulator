#!/usr/bin/env bash
set -euo pipefail

if command -v k3s >/dev/null 2>&1; then
  echo "k3s is already installed"
  exit 0
fi

curl -sfL https://get.k3s.io | sh -s - server \
  --disable traefik \
  --write-kubeconfig-mode 644

sudo mkdir -p /home/"${SUDO_USER:-$USER}"/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/"${SUDO_USER:-$USER}"/.kube/config
sudo chown "${SUDO_USER:-$USER}:${SUDO_USER:-$USER}" /home/"${SUDO_USER:-$USER}"/.kube/config
