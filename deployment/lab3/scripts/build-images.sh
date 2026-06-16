#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

docker build \
  -t hiveemulator/communication-control:lab3 \
  -f "${ROOT_DIR}/src/CommunicationControl/DevOpsProject/Dockerfile" \
  "${ROOT_DIR}/src/CommunicationControl"

docker build \
  -t hiveemulator/hive-mind:lab3 \
  -f "${ROOT_DIR}/src/CommunicationControl/DevOpsProject.HiveMind.API/Dockerfile" \
  "${ROOT_DIR}/src/CommunicationControl"

docker build \
  -t hiveemulator/map-client:lab3 \
  -f "${ROOT_DIR}/src/MapClient/Dockerfile" \
  "${ROOT_DIR}/src/MapClient"

docker pull redis:7-alpine
