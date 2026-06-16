#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
RGR_DIR="${ROOT_DIR}/deployment/rgr/k8s"

kubectl apply -f "${RGR_DIR}/00-namespace"
kubectl apply -f "${RGR_DIR}/10-infrastructure"
kubectl apply -f "${RGR_DIR}/20-app"
kubectl apply -f "${RGR_DIR}/30-ingress"

kubectl -n hiveemulator-rgr rollout status deployment/redis --timeout=180s
kubectl -n hiveemulator-rgr rollout status deployment/communication-control --timeout=180s
kubectl -n hiveemulator-rgr rollout status deployment/hive-mind --timeout=180s
kubectl -n hiveemulator-rgr rollout status deployment/map-client --timeout=180s

kubectl -n hiveemulator-rgr get pods -o wide
kubectl -n hiveemulator-rgr get svc
kubectl -n hiveemulator-rgr get ingress
