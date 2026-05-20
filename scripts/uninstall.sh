#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-m2cloud}"
HELM_RELEASE="${HELM_RELEASE:-dotnetgigs}"

helm uninstall "$HELM_RELEASE" -n "$NAMESPACE" || true
kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
