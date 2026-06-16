#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

docker compose -f "${ROOT_DIR}/deployment/lab4/docker-compose.yml" down
