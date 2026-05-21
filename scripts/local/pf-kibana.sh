#!/usr/bin/env bash
set -euo pipefail

echo "Kibana: http://localhost:5601"
echo "Login: elastic"
echo "Password:"
kubectl get secret -n observability elasticsearch-master-credentials \
  -o jsonpath="{.data.password}" 2>/dev/null | base64 -d || true
echo
kubectl port-forward -n observability svc/kibana 5601:5601
