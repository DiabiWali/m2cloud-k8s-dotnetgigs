#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
RELEASE_NAME=${RELEASE_NAME:-dotnetgigs}
NAMESPACE=${NAMESPACE:-m2cloud}
mkdir -p _rendered

if command -v helm >/dev/null 2>&1; then
  helm template "$RELEASE_NAME" helm/dotnetgigs \
    --namespace "$NAMESPACE" \
    -f helm/dotnetgigs/values.yaml \
    -f environments/dev/values-dev.yaml \
    > _rendered/dotnetgigs-dev.yaml
  echo "Rendu Helm généré: _rendered/dotnetgigs-dev.yaml"
else
  echo "Helm absent, rendu impossible."
  exit 1
fi
