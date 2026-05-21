#!/usr/bin/env bash
set -euo pipefail

echo "Argo CD: https://localhost:8080"
echo "Login: admin"
echo "Password:"
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" 2>/dev/null | base64 -d || true
echo
kubectl port-forward svc/argocd-server -n argocd 8080:443
