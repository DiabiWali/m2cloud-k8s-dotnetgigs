#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
NAMESPACE=${NAMESPACE:-m2cloud}
INGRESS_HOST=${INGRESS_HOST:-dotnetgigs.local}

echo "== HPA avant charge =="
kubectl get hpa -n "$NAMESPACE" || true

if command -v k6 >/dev/null 2>&1; then
  BASE_URL="https://${INGRESS_HOST}" k6 run tests/load/k6-hpa.js
else
  echo "k6 absent. Lancement d'une charge simple avec busybox/wget."
  kubectl -n "$NAMESPACE" run hpa-load --rm -i --restart=Never --image=busybox:1.36 -- \
    /bin/sh -c "while true; do wget -q -O- http://webmvc >/dev/null; done" || true
fi

echo "== HPA après charge =="
kubectl get hpa -n "$NAMESPACE" -w
