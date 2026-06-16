#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
RGR_DIR="${ROOT_DIR}/deployment/rgr/k8s"

kubectl delete -f "${RGR_DIR}/30-ingress" --ignore-not-found
kubectl delete -f "${RGR_DIR}/20-app" --ignore-not-found
kubectl delete -f "${RGR_DIR}/10-infrastructure" --ignore-not-found
kubectl delete -f "${RGR_DIR}/00-namespace" --ignore-not-found
