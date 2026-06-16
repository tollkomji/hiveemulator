#!/usr/bin/env bash
set -euo pipefail

docker rm -f lab3-map-client lab3-hive-mind lab3-communication-control lab3-redis >/dev/null 2>&1 || true
docker network rm hiveemulator-lab3 >/dev/null 2>&1 || true
