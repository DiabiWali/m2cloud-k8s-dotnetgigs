#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
NAMESPACE=${NAMESPACE:-m2cloud}
DEPLOYMENT=${1:-webmvc}
IMAGE=${2:-nginx:1.27-alpine}

echo "Démonstration RollingUpdate sur deployment/$DEPLOYMENT avec image $IMAGE"
kubectl -n "$NAMESPACE" set image deployment/$DEPLOYMENT $DEPLOYMENT=$IMAGE || true
kubectl -n "$NAMESPACE" rollout status deployment/$DEPLOYMENT --timeout=180s || true
echo "Pour revenir: helm upgrade --install ${RELEASE_NAME:-dotnetgigs} helm/dotnetgigs -n $NAMESPACE -f helm/dotnetgigs/values.yaml -f environments/dev/values-dev.yaml"
