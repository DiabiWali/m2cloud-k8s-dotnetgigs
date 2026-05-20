#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
KIND_CLUSTER_NAME=${KIND_CLUSTER_NAME:-m2cloud}
KIND_CONFIG=${KIND_CONFIG:-clusters/kind/kind-config.yaml}

if ! command -v kind >/dev/null 2>&1; then
  echo "kind n'est pas installé. Installe-le via: brew install kind"
  exit 1
fi

if kind get clusters | grep -qx "$KIND_CLUSTER_NAME"; then
  echo "Cluster kind '$KIND_CLUSTER_NAME' déjà présent."
else
  kind create cluster --name "$KIND_CLUSTER_NAME" --config "$KIND_CONFIG"
fi

kubectl cluster-info --context "kind-${KIND_CLUSTER_NAME}"
