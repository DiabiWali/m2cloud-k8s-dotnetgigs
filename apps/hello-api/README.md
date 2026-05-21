# hello-api

API de démonstration onboardée depuis Backstage

## Endpoints

| Endpoint | Description |
|---|---|
| `/health` | Health check |
| `/version` | Version applicative |
| `/api/hello` | Endpoint de démonstration |
| `/metrics` | Métriques Prometheus minimales |

## Build local

docker build -t hello-api:local .

docker run --rm -p 8080:8080 hello-api:local

## Déploiement Kubernetes

helm upgrade --install hello-api ./helm -n m2cloud --create-namespace
