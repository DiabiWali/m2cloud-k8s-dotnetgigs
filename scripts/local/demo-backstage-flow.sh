#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-hello-api}"
BASE_BRANCH="${BASE_BRANCH:-feat/developer-portal-backstage}"
NAMESPACE="${NAMESPACE:-m2cloud}"
KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-m2cloud}"
LOCAL_PORT="${LOCAL_PORT:-8089}"
APP_PORT="${APP_PORT:-8080}"

cd "$(dirname "$0")/../.."

echo "============================================================"
echo "M2Cloud Backstage demo flow"
echo "Application : ${APP_NAME}"
echo "Base branch : ${BASE_BRANCH}"
echo "Namespace   : ${NAMESPACE}"
echo "============================================================"

echo ""
echo "1. Vérification GitHub CLI"
gh auth status >/dev/null

echo ""
echo "2. Recherche d'une Pull Request Backstage ouverte"
PR_NUMBER="$(gh pr list \
  --head "backstage-onboard-${APP_NAME}" \
  --state open \
  --json number \
  --jq '.[0].number' 2>/dev/null || true)"

if [ -n "${PR_NUMBER}" ] && [ "${PR_NUMBER}" != "null" ]; then
  echo "Pull Request trouvée : #${PR_NUMBER}"

  echo ""
  echo "3. Attente des checks CI"
  gh pr checks "${PR_NUMBER}" --watch

  echo ""
  echo "4. Merge de la Pull Request"
  gh pr merge "${PR_NUMBER}" --squash --delete-branch
else
  echo "Aucune PR ouverte trouvée pour backstage-onboard-${APP_NAME}."
  echo "On continue si l'application existe déjà localement."
fi

echo ""
echo "5. Mise à jour de la branche ${BASE_BRANCH}"
git fetch origin
git checkout "${BASE_BRANCH}"
git pull --ff-only

if [ ! -d "apps/${APP_NAME}" ]; then
  echo "ERREUR : apps/${APP_NAME} introuvable."
  echo "Vérifie que le template Backstage a bien généré et mergé l'application."
  exit 1
fi

if [ ! -f "gitops/apps/${APP_NAME}-application.yaml" ]; then
  echo "ERREUR : gitops/apps/${APP_NAME}-application.yaml introuvable."
  exit 1
fi

echo ""
echo "6. Build de l'image Docker locale"
docker build -t "${APP_NAME}:local" "apps/${APP_NAME}"

echo ""
echo "7. Chargement de l'image dans kind"
kind load docker-image "${APP_NAME}:local" --name "${KIND_CLUSTER_NAME}"

echo ""
echo "8. Application du manifeste Argo CD"
kubectl apply -f "gitops/apps/${APP_NAME}-application.yaml"

echo ""
echo "9. Attente Argo CD Synced / Healthy"
for i in {1..60}; do
  SYNC_STATUS="$(kubectl get application "${APP_NAME}" -n argocd -o jsonpath='{.status.sync.status}' 2>/dev/null || true)"
  HEALTH_STATUS="$(kubectl get application "${APP_NAME}" -n argocd -o jsonpath='{.status.health.status}' 2>/dev/null || true)"

  echo "Argo CD status: sync=${SYNC_STATUS:-unknown}, health=${HEALTH_STATUS:-unknown}"

  if [ "${SYNC_STATUS}" = "Synced" ] && [ "${HEALTH_STATUS}" = "Healthy" ]; then
    break
  fi

  sleep 5
done

if [ "${SYNC_STATUS:-}" != "Synced" ] || [ "${HEALTH_STATUS:-}" != "Healthy" ]; then
  echo "ERREUR : l'application n'est pas Synced / Healthy."
  kubectl get application "${APP_NAME}" -n argocd || true
  kubectl describe application "${APP_NAME}" -n argocd | tail -80 || true
  exit 1
fi

echo ""
echo "10. Vérification Kubernetes"
kubectl rollout status "deploy/${APP_NAME}" -n "${NAMESPACE}" --timeout=180s
kubectl get deploy,pod,svc,hpa,pdb -n "${NAMESPACE}" | grep "${APP_NAME}" || true

echo ""
echo "11. Test HTTP via port-forward"
pkill -f "kubectl port-forward svc/${APP_NAME}.*${LOCAL_PORT}:${APP_PORT}" 2>/dev/null || true

kubectl port-forward "svc/${APP_NAME}" -n "${NAMESPACE}" "${LOCAL_PORT}:${APP_PORT}" >/tmp/${APP_NAME}-port-forward.log 2>&1 &
PF_PID=$!

cleanup() {
  kill "${PF_PID}" 2>/dev/null || true
}
trap cleanup EXIT

sleep 4

curl -f "http://localhost:${LOCAL_PORT}/health"
echo ""
curl -f "http://localhost:${LOCAL_PORT}/version"
echo ""
curl -f "http://localhost:${LOCAL_PORT}/api/hello"
echo ""
curl -f "http://localhost:${LOCAL_PORT}/metrics"
echo ""

echo ""
echo "============================================================"
echo "Démo terminée avec succès"
echo "Backstage → GitHub PR → CI → Merge → Argo CD → Kubernetes"
echo "Application disponible via port-forward : http://localhost:${LOCAL_PORT}"
echo "============================================================"
