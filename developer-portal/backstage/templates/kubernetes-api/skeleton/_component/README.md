# ${{ values.component_id }}

${{ values.description }}

## Endpoints

| Endpoint | Description |
|---|---|
| `/health` | Health check |
| `/version` | Version applicative |
| `/api/hello` | Endpoint de démonstration |
| `/metrics` | Métriques Prometheus minimales |

## Build local

docker build -t ${{ values.component_id }}:local .

docker run --rm -p ${{ values.port }}:${{ values.port }} ${{ values.component_id }}:local

## Déploiement Kubernetes

helm upgrade --install ${{ values.component_id }} ./helm -n ${{ values.namespace }} --create-namespace
