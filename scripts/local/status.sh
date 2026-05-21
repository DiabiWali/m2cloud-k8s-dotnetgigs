#!/usr/bin/env bash
set -euo pipefail

echo "== Docker / Kind =="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | head -20 || true
echo
kind get clusters || true
echo

echo "== Kubernetes Nodes =="
kubectl get nodes -o wide
echo

echo "== DotNetGigs / m2cloud =="
helm list -n m2cloud || true
kubectl get pods -n m2cloud -o wide || true
kubectl get svc -n m2cloud || true
kubectl get ingress -n m2cloud || true
kubectl get hpa -n m2cloud || true
echo

echo "== Observability =="
kubectl get pods -n observability || true
echo

echo "== Argo CD =="
kubectl get applications -n argocd || true
echo

echo "== Smoke test =="
curl -k -I https://dotnetgigs.local || true
