#!/usr/bin/env bash
set -euo pipefail

kubectl get nodes -o wide
kubectl -n hiveemulator-rgr get all
kubectl -n hiveemulator-rgr get ingress
kubectl -n ingress-nginx get service ingress-nginx-controller
