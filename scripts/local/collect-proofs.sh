#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

mkdir -p proofs

helm list -n m2cloud > proofs/00-helm-list.txt || true
helm status dotnetgigs -n m2cloud > proofs/00-helm-status.txt || true

kubectl get nodes -o wide > proofs/01-nodes.txt || true
kubectl get pods -n m2cloud -o wide > proofs/02-pods-m2cloud.txt || true
kubectl get svc -n m2cloud > proofs/03-services.txt || true
kubectl get ingress -n m2cloud > proofs/04-ingress.txt || true
kubectl get hpa -n m2cloud > proofs/05-hpa.txt || true
kubectl get endpointslice -n m2cloud > proofs/06-endpointslices.txt || true

kubectl get pods -n observability > proofs/07-observability-pods.txt || true
kubectl get servicemonitor -A > proofs/08-servicemonitors.txt || true
kubectl get prometheusrule -A > proofs/09-prometheusrules.txt || true
kubectl get svc -n observability > proofs/12-observability-services.txt || true
kubectl logs -n observability daemonset/fluent-bit --tail=80 > proofs/13-fluent-bit-logs.txt || true

ELASTIC_PASSWORD=$(kubectl get secret -n observability elasticsearch-master-credentials \
  -o jsonpath="{.data.password}" 2>/dev/null | base64 -d || true)

if [ -n "${ELASTIC_PASSWORD}" ]; then
  kubectl exec -n observability elasticsearch-master-0 -- \
    curl -k -u elastic:${ELASTIC_PASSWORD} https://localhost:9200/_cat/indices?v \
    > proofs/14-elasticsearch-indices.txt || true
fi

kubectl get applications -n argocd > proofs/15-argocd-applications.txt || true
kubectl describe application dotnetgigs -n argocd > proofs/16-argocd-dotnetgigs-description.txt || true
kubectl get pods -n argocd > proofs/17-argocd-pods.txt || true

curl -k -I https://dotnetgigs.local > proofs/10-curl-home-headers.txt || true
curl -k https://dotnetgigs.local | head -120 > proofs/11-curl-home-html.txt || true


# Data orchestration proofs
kubectl get statefulset -n m2cloud -o wide > proofs/18-data-statefulsets.txt || true
kubectl get pvc -n m2cloud -o wide > proofs/19-data-pvc.txt || true
kubectl get cronjob,job -n m2cloud -o wide > proofs/20-data-jobs-cronjobs.txt || true
kubectl describe pvc sql-data-pvc -n m2cloud > proofs/21-sql-pvc-detail.txt || true
kubectl describe cronjob sql-data-backup -n m2cloud > proofs/22-sql-backup-cronjob.txt || true
kubectl exec -n m2cloud sql-data-0 -- sh -c 'ls -lh /var/opt/mssql/data/*.bak 2>/dev/null || true' > proofs/23-sql-backup-files.txt || true
kubectl logs -n m2cloud statefulset/sql-data --tail=120 > proofs/24-sql-data-logs.txt || true

tar -czf proofs-m2cloud-k8s.tar.gz proofs

echo "Preuves générées dans ./proofs"
echo "Archive générée : ./proofs-m2cloud-k8s.tar.gz"
