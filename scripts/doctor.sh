#!/usr/bin/env bash
set -euo pipefail

required=(docker kubectl)
optional=(kind helm openssl curl jq yq trivy kubeconform k6)

echo "== Vérification des prérequis =="
for bin in "${required[@]}"; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "ERREUR: $bin est requis mais absent."
    exit 1
  fi
  echo "OK: $bin -> $(command -v "$bin")"
done

for bin in "${optional[@]}"; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "OK: $bin -> $(command -v "$bin")"
  else
    echo "WARN: $bin absent. Certaines commandes avancées seront ignorées."
  fi
done

echo
echo "Contexte Docker: $(docker context show 2>/dev/null || true)"
kubectl version --client=true --short 2>/dev/null || kubectl version --client=true || true
