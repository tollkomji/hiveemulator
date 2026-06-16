#!/usr/bin/env sh
set -eu

: "${MAP_CLIENT_API_URL:?Set MAP_CLIENT_API_URL to the Communication Control public API URL}"

cat >/usr/share/nginx/html/config.json <<EOF
{
  "API": "${MAP_CLIENT_API_URL}"
}
EOF
