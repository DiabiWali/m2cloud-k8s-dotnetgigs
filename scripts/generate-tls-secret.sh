#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
NAMESPACE=${NAMESPACE:-m2cloud}
INGRESS_HOST=${INGRESS_HOST:-dotnetgigs.local}
TLS_SECRET_NAME=${TLS_SECRET_NAME:-dotnetgigs-tls}
mkdir -p .certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ".certs/${INGRESS_HOST}.key" \
  -out ".certs/${INGRESS_HOST}.crt" \
  -subj "/CN=${INGRESS_HOST}/O=m2cloud" \
  -addext "subjectAltName=DNS:${INGRESS_HOST}"

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$NAMESPACE" create secret tls "$TLS_SECRET_NAME" \
  --key ".certs/${INGRESS_HOST}.key" \
  --cert ".certs/${INGRESS_HOST}.crt" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Certificat TLS installé: secret/$TLS_SECRET_NAME dans namespace $NAMESPACE"
echo "Ajoute au /etc/hosts si nécessaire: 127.0.0.1 $INGRESS_HOST"
