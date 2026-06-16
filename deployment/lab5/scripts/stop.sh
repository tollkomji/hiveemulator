#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
ENV_FILE="${ROOT_DIR}/deployment/lab5/.env.runtime"
COMPOSE_FILE="${ROOT_DIR}/deployment/lab5/docker-compose.deploy.yml"

if [[ -f "${ENV_FILE}" ]]; then
  docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" down
else
  REGISTRY=ghcr.io IMAGE_REPOSITORY=local/hiveemulator IMAGE_TAG=local docker compose -f "${COMPOSE_FILE}" down
fi
