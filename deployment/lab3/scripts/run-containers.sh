#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
PUBLIC_HOST="${1:-localhost}"
NETWORK_NAME="hiveemulator-lab3"
CONFIG_FILE="${ROOT_DIR}/deployment/lab3/config/config.runtime.json"

cat >"${CONFIG_FILE}" <<EOF
{
  "API": "http://${PUBLIC_HOST}:8080/api/v1/client"
}
EOF

docker rm -f lab3-map-client lab3-hive-mind lab3-communication-control lab3-redis >/dev/null 2>&1 || true
docker network create "${NETWORK_NAME}" >/dev/null 2>&1 || true

docker run -d \
  --name lab3-redis \
  --network "${NETWORK_NAME}" \
  -p 6379:6379 \
  redis:7-alpine

docker run -d \
  --name lab3-communication-control \
  --network "${NETWORK_NAME}" \
  -e ASPNETCORE_ENVIRONMENT=Docker \
  -e Redis__ConnectionString=lab3-redis:6379 \
  -e Urls=http://0.0.0.0:8080 \
  -e BasePath= \
  -p 8080:8080 \
  hiveemulator/communication-control:lab3

docker run -d \
  --name lab3-hive-mind \
  --network "${NETWORK_NAME}" \
  -e ASPNETCORE_ENVIRONMENT=Docker \
  -e Urls=http://0.0.0.0:5149 \
  -e CommunicationConfiguration__RequestSchema=http \
  -e CommunicationConfiguration__CommunicationControlIP=lab3-communication-control \
  -e CommunicationConfiguration__CommunicationControlPort=8080 \
  -e CommunicationConfiguration__CommunicationControlPath=api/v1/hive \
  -e CommunicationConfiguration__HiveIP=lab3-hive-mind \
  -e CommunicationConfiguration__HivePort=5149 \
  -e CommunicationConfiguration__HiveID=1 \
  -p 5149:5149 \
  hiveemulator/hive-mind:lab3

docker run -d \
  --name lab3-map-client \
  --network "${NETWORK_NAME}" \
  -v "${CONFIG_FILE}:/usr/share/nginx/html/config.json:ro" \
  -p 3000:80 \
  hiveemulator/map-client:lab3

docker ps --filter "name=lab3-"
