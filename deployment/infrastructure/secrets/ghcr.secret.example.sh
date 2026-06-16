#!/usr/bin/env sh
set -eu

# Create a GitHub token with read:packages access and pass it through GHCR_TOKEN.
# Example:
#   GHCR_USERNAME=tollkomji GHCR_TOKEN=github_pat_xxx ./deployment/infrastructure/secrets/ghcr.secret.example.sh

kubectl create secret docker-registry ghcr-registry-secret \
  --docker-server=ghcr.io \
  --docker-username="${GHCR_USERNAME:?Set GHCR_USERNAME}" \
  --docker-password="${GHCR_TOKEN:?Set GHCR_TOKEN}" \
  --docker-email="${GHCR_EMAIL:-noreply@example.com}" \
  --namespace="${K8S_NAMESPACE:-default}"
