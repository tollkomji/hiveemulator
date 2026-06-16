#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
COMPOSE_FILE="${ROOT_DIR}/deployment/lab6/docker-compose.monitoring.yml"

if ! docker network inspect hiveemulator-lab5 >/dev/null 2>&1; then
  echo "Docker network hiveemulator-lab5 is required. Start Lab 5 before Lab 6."
  exit 1
fi

docker compose -f "${COMPOSE_FILE}" up -d
docker compose -f "${COMPOSE_FILE}" ps
