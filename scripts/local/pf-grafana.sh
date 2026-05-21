#!/usr/bin/env bash
set -euo pipefail

echo "Grafana: http://localhost:3000"
echo "Login: admin"
echo "Password:"
kubectl get secret -n observability kube-prometheus-stack-grafana \
  -o jsonpath="{.data.admin-password}" 2>/dev/null | base64 -d || true
echo
kubectl port-forward -n observability svc/kube-prometheus-stack-grafana 3000:80
