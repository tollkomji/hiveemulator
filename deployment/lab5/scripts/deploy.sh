#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
LAB_DIR="${ROOT_DIR}/deployment/lab5"
CONFIG_FILE="${LAB_DIR}/config/config.runtime.json"
ENV_FILE="${LAB_DIR}/.env.runtime"

PUBLIC_HOST="${PUBLIC_HOST:-localhost}"
REGISTRY="${REGISTRY:-ghcr.io}"

: "${IMAGE_REPOSITORY:?IMAGE_REPOSITORY is required, for example tollkomji/hiveemulator}"
: "${IMAGE_TAG:?IMAGE_TAG is required, for example a commit SHA or latest}"

cat >"${CONFIG_FILE}" <<EOF
{
  "API": "http://${PUBLIC_HOST}:8080/api/v1/client"
}
EOF

cat >"${ENV_FILE}" <<EOF
REGISTRY=${REGISTRY}
IMAGE_REPOSITORY=${IMAGE_REPOSITORY}
IMAGE_TAG=${IMAGE_TAG}
EOF

if [[ -x "${ROOT_DIR}/deployment/lab3/scripts/stop-containers.sh" ]]; then
  "${ROOT_DIR}/deployment/lab3/scripts/stop-containers.sh" || true
fi

if [[ -x "${ROOT_DIR}/deployment/lab4/scripts/stop.sh" ]]; then
  "${ROOT_DIR}/deployment/lab4/scripts/stop.sh" || true
fi

docker compose --env-file "${ENV_FILE}" -f "${LAB_DIR}/docker-compose.deploy.yml" pull
docker compose --env-file "${ENV_FILE}" -f "${LAB_DIR}/docker-compose.deploy.yml" up -d
docker compose --env-file "${ENV_FILE}" -f "${LAB_DIR}/docker-compose.deploy.yml" ps
