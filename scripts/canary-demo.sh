#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
NAMESPACE=${NAMESPACE:-m2cloud}

echo "Déploiement d'un canary webmvc-v2 à 1 replica."
kubectl apply -n "$NAMESPACE" -f k8s/overlays/canary/webmvc-canary.yaml
kubectl -n "$NAMESPACE" rollout status deployment/webmvc-canary --timeout=180s || true
kubectl -n "$NAMESPACE" get deploy,svc -l canary=true
