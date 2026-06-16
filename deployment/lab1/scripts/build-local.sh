#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
OUT_DIR="${ROOT_DIR}/build/lab1"

rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}/api" "${OUT_DIR}/hive-mind" "${OUT_DIR}/map-client"

dotnet publish \
  "${ROOT_DIR}/src/CommunicationControl/DevOpsProject/DevOpsProject.CommunicationControl.API.csproj" \
  --configuration Release \
  --output "${OUT_DIR}/api"

dotnet publish \
  "${ROOT_DIR}/src/CommunicationControl/DevOpsProject.HiveMind.API/DevOpsProject.HiveMind.API.csproj" \
  --configuration Release \
  --output "${OUT_DIR}/hive-mind"

npm ci --prefix "${ROOT_DIR}/src/MapClient"
npm run build --prefix "${ROOT_DIR}/src/MapClient"

cp -R "${ROOT_DIR}/src/MapClient/dist/." "${OUT_DIR}/map-client/"
cp "${ROOT_DIR}/deployment/lab1/config/config.template.json" "${OUT_DIR}/map-client/config.json"

(
  cd "${OUT_DIR}/api"
  zip -qr "${OUT_DIR}/communication-control-api.zip" .
)

(
  cd "${OUT_DIR}/hive-mind"
  zip -qr "${OUT_DIR}/hive-mind-api.zip" .
)

(
  cd "${OUT_DIR}/map-client"
  zip -qr "${OUT_DIR}/map-client.zip" .
)

cat <<EOF
Lab 1 artifacts are ready in:
  ${OUT_DIR}

Before uploading map-client.zip, edit:
  ${OUT_DIR}/map-client/config.json

Replace <SERVER_IP> with the VPS public IP and re-run:
  cd ${OUT_DIR}/map-client && zip -qr ${OUT_DIR}/map-client.zip .
EOF
