#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
NAMESPACE=${NAMESPACE:-m2cloud}
mkdir -p _evidence

kubectl get nodes -o wide > _evidence/01-nodes.txt || true
kubectl get all -n "$NAMESPACE" -o wide > _evidence/02-workloads.txt || true
kubectl get hpa -n "$NAMESPACE" -o yaml > _evidence/03-hpa.yaml || true
kubectl get networkpolicy -n "$NAMESPACE" -o yaml > _evidence/04-networkpolicies.yaml || true
kubectl get ingress -n "$NAMESPACE" -o yaml > _evidence/05-ingress-tls.yaml || true
kubectl top pods -n "$NAMESPACE" > _evidence/06-pod-metrics.txt || true
helm list -A > _evidence/07-helm-releases.txt || true
helm get values "${RELEASE_NAME:-dotnetgigs}" -n "$NAMESPACE" > _evidence/08-helm-values.yaml || true

echo "Preuves collectées dans _evidence/. Tu peux les capturer dans les slides."
