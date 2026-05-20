#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
REGISTRY=${REGISTRY:-ghcr.io/example}
IMAGE_TAG=${IMAGE_TAG:-1.0.0}
APP_DIR=${APP_DIR:-appscore}

if [ ! -d "$APP_DIR" ]; then
  echo "Le dossier $APP_DIR est absent. Lance d'abord: make bootstrap"
  exit 1
fi

build_image() {
  local name=$1
  local dockerfile=$2
  echo "== Build $name =="
  docker build \
    -f "$dockerfile" \
    -t "$REGISTRY/$name:$IMAGE_TAG" \
    "$APP_DIR"
}

build_image m2cloud-webmvc dockerfiles/Web.Dockerfile
build_image m2cloud-applicants-api dockerfiles/Applicants.Api.Dockerfile
build_image m2cloud-jobs-api dockerfiles/Jobs.Api.Dockerfile
build_image m2cloud-identity-api dockerfiles/Identity.Api.Dockerfile

# sql-data nécessite que les scripts SQL existent dans le contexte upstream.
if [ -f "$APP_DIR/SqlCmdStartup.sh" ] || find "$APP_DIR" -name SqlCmdStartup.sh | grep -q .; then
  docker build \
  -t "${REGISTRY}/m2cloud-sql-data:${IMAGE_TAG}" \
  -f "${APP_DIR}/Database/Dockerfile" \
  "${APP_DIR}/Database"
else
  echo "WARN: scripts SQL non détectés. Le chart peut utiliser une image sql-data déjà publiée."
fi
