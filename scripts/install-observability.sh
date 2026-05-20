#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
NAMESPACE=${NAMESPACE:-m2cloud}

if ! command -v helm >/dev/null 2>&1; then
  echo "Helm est requis pour installer Prometheus et EFK."
  exit 1
fi

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo add elastic https://helm.elastic.co >/dev/null
helm repo add fluent https://fluent.github.io/helm-charts >/dev/null
helm repo update >/dev/null

kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  -n observability \
  -f observability/prometheus/kube-prometheus-stack-values.yaml \
  --wait --timeout 10m

helm upgrade --install elasticsearch elastic/elasticsearch \
  -n observability \
  -f observability/logging/efk/elasticsearch-values.yaml \
  --wait --timeout 10m || true

helm upgrade --install kibana elastic/kibana \
  -n observability \
  -f observability/logging/efk/kibana-values.yaml \
  --wait --timeout 10m || true

helm upgrade --install fluent-bit fluent/fluent-bit \
  -n observability \
  -f observability/logging/efk/fluent-bit-values.yaml \
  --wait --timeout 5m || true

kubectl apply -f observability/prometheus/m2cloud-service-monitor.yaml || true
kubectl apply -f observability/prometheus/prometheus-rules.yaml || true

echo "Prometheus/Grafana/EFK installés ou déclenchés. Vérifie: kubectl get pods -n observability"
