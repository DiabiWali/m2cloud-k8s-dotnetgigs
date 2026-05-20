#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
UPSTREAM_REPO=${UPSTREAM_REPO:-https://github.com/bart120/m2cloud.git}
UPSTREAM_APP_PATH=${UPSTREAM_APP_PATH:-appscore}

if [ -d "$UPSTREAM_APP_PATH" ]; then
  echo "$UPSTREAM_APP_PATH existe déjà. Rien à faire."
  exit 0
fi

echo "Clone du repo du cours: $UPSTREAM_REPO"
git clone --depth 1 "$UPSTREAM_REPO" _upstream-m2cloud

# On conserve une logique souple parce que le sujet peut évoluer côté enseignant.
if [ -d "_upstream-m2cloud/appscore" ]; then
  cp -R _upstream-m2cloud/appscore "$UPSTREAM_APP_PATH"
elif [ -d "_upstream-m2cloud/projet_k8s/appscore" ]; then
  cp -R _upstream-m2cloud/projet_k8s/appscore "$UPSTREAM_APP_PATH"
else
  mkdir -p "$UPSTREAM_APP_PATH"
  cp -R _upstream-m2cloud/. "$UPSTREAM_APP_PATH/"
  echo "WARN: dossier appscore dédié non trouvé. Le repo complet a été copié dans $UPSTREAM_APP_PATH. Ajuste les Dockerfiles si besoin."
fi

rm -rf _upstream-m2cloud

echo "Code upstream prêt dans $UPSTREAM_APP_PATH"
