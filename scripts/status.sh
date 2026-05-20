#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
NAMESPACE=${NAMESPACE:-m2cloud}

echo "== Nodes =="
kubectl get nodes -o wide

echo "\n== Namespace $NAMESPACE =="
kubectl get all,ingress,secret,networkpolicy,hpa,pdb -n "$NAMESPACE" -o wide || true

echo "\n== Events récents =="
kubectl get events -n "$NAMESPACE" --sort-by=.lastTimestamp | tail -30 || true

echo "\n== Ressources pods =="
kubectl top pods -n "$NAMESPACE" || true
