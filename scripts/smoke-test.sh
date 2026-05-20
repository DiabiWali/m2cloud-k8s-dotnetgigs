#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
INGRESS_HOST=${INGRESS_HOST:-dotnetgigs.local}
URL="https://${INGRESS_HOST}"

echo "Test HTTP/TLS sur $URL"
curl -k -I --connect-timeout 5 "$URL" || {
  echo "Le test via ingress a échoué. Essaie un port-forward:"
  echo "kubectl -n ${NAMESPACE:-m2cloud} port-forward svc/webmvc 8080:80"
  exit 1
}
