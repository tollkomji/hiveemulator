#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
PUBLIC_HOST="${1:-localhost}"
CONFIG_FILE="${ROOT_DIR}/deployment/lab4/config/config.runtime.json"

cat >"${CONFIG_FILE}" <<EOF
{
  "API": "http://${PUBLIC_HOST}:8080/api/v1/client"
}
EOF

docker compose -f "${ROOT_DIR}/deployment/lab4/docker-compose.yml" up -d --build
docker compose -f "${ROOT_DIR}/deployment/lab4/docker-compose.yml" ps
