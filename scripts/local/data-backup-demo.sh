#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-m2cloud}"
JOB_NAME="sql-data-backup-manual-$(date +%Y%m%d%H%M%S)"

echo "============================================================"
echo "M2Cloud Data Backup Demo"
echo "Namespace : ${NAMESPACE}"
echo "Job       : ${JOB_NAME}"
echo "============================================================"

echo ""
echo "1. Vérification des composants data"
kubectl get statefulset,pod,pvc,cronjob -n "${NAMESPACE}" | grep -E "sql|backup" || true

echo ""
echo "2. Création d'un Job manuel depuis le CronJob"
kubectl create job "${JOB_NAME}" --from=cronjob/sql-data-backup -n "${NAMESPACE}"

echo ""
echo "3. Attente de la fin du Job"
kubectl wait --for=condition=complete "job/${JOB_NAME}" -n "${NAMESPACE}" --timeout=180s

echo ""
echo "4. Logs du Job"
kubectl logs "job/${JOB_NAME}" -n "${NAMESPACE}"

echo ""
echo "5. Sauvegardes présentes dans le PVC SQL"
kubectl exec -n "${NAMESPACE}" sql-data-0 -- sh -c 'ls -lh /var/opt/mssql/data/*.bak 2>/dev/null || true'

echo ""
echo "============================================================"
echo "Backup SQL terminé"
echo "============================================================"
