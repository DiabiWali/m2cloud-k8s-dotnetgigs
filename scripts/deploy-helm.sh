#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
RELEASE_NAME=${RELEASE_NAME:-dotnetgigs}
NAMESPACE=${NAMESPACE:-m2cloud}
REGISTRY=${REGISTRY:-ghcr.io/example}
IMAGE_TAG=${IMAGE_TAG:-1.0.0}
INGRESS_HOST=${INGRESS_HOST:-dotnetgigs.local}
TLS_SECRET_NAME=${TLS_SECRET_NAME:-dotnetgigs-tls}

helm upgrade --install "$RELEASE_NAME" helm/dotnetgigs \
  --namespace "$NAMESPACE" \
  --create-namespace \
  -f helm/dotnetgigs/values.yaml \
  -f environments/dev/values-dev.yaml \
  --set global.imageRegistry="$REGISTRY" \
  --set global.imageTag="$IMAGE_TAG" \
  --set ingress.host="$INGRESS_HOST" \
  --set ingress.tlsSecretName="$TLS_SECRET_NAME" \
  --set secrets.sqlSaPassword="${SQL_SA_PASSWORD:-Pass@word12345!}" \
  --set secrets.rabbitmqDefaultUser="${RABBITMQ_DEFAULT_USER:-m2cloud}" \
  --set secrets.rabbitmqDefaultPass="${RABBITMQ_DEFAULT_PASS:-M2CloudRabbit123!}" \
  --wait --timeout 10m
