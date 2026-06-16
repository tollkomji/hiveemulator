#!/usr/bin/env bash
set -euo pipefail

MANIFEST_URL="https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/cloud/deploy.yaml"

kubectl apply -f "${MANIFEST_URL}"
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller --timeout=180s

kubectl -n ingress-nginx patch service ingress-nginx-controller --type='merge' -p '{
  "spec": {
    "type": "NodePort",
    "ports": [
      {
        "name": "http",
        "port": 80,
        "protocol": "TCP",
        "targetPort": "http",
        "nodePort": 32080
      },
      {
        "name": "https",
        "port": 443,
        "protocol": "TCP",
        "targetPort": "https",
        "nodePort": 32443
      }
    ]
  }
}'

kubectl -n ingress-nginx get service ingress-nginx-controller
