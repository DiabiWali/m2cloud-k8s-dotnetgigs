#!/usr/bin/env bash
set -euo pipefail
./scripts/render-helm.sh

if command -v helm >/dev/null 2>&1; then
  helm lint helm/dotnetgigs -f environments/dev/values-dev.yaml
fi

if command -v kubeconform >/dev/null 2>&1; then
  kubeconform -strict -summary -ignore-missing-schemas _rendered/dotnetgigs-dev.yaml
else
  echo "WARN: kubeconform absent, validation Kubernetes ignorée."
fi

if command -v trivy >/dev/null 2>&1; then
  trivy config --exit-code 0 --severity HIGH,CRITICAL .
else
  echo "WARN: trivy absent, scan IaC ignoré."
fi
