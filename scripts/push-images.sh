#!/usr/bin/env bash
set -euo pipefail
source .env 2>/dev/null || true
REGISTRY=${REGISTRY:-ghcr.io/example}
IMAGE_TAG=${IMAGE_TAG:-1.0.0}
for image in m2cloud-webmvc m2cloud-applicants-api m2cloud-jobs-api m2cloud-identity-api m2cloud-sql-data; do
  docker push "$REGISTRY/$image:$IMAGE_TAG"
done
