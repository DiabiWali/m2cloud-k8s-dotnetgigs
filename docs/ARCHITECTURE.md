# Architecture technique

## Vue logique

L'application est structurée en couches:

- **Entrée externe**: Ingress NGINX avec TLS auto-signé pour le TP.
- **Frontend**: `webmvc`, seul service exposé à l'extérieur.
- **APIs internes**: `applicants-api`, `jobs-api`, `identity-api`.
- **Données et messaging**: `sql-data`, `rabbitmq`, `user-data` Redis.
- **Observabilité**: Prometheus, Grafana, kube-state-metrics, Fluent Bit, Elasticsearch, Kibana.

## Principes d'architecture

Le design applique le principe de moindre exposition. Aucun service technique n'est publié en NodePort ou LoadBalancer. Les flux internes sont filtrés par NetworkPolicy.

Les paramètres applicatifs sont portés par ConfigMap, tandis que les secrets sont dans Kubernetes Secret. Pour une production réelle, le dépôt prévoit une trajectoire vers External Secrets ou un coffre de secrets cloud.

## Haute disponibilité

Les composants applicatifs stateless ont plusieurs replicas. Des RollingUpdates empêchent l'indisponibilité pendant les mises à jour. Les PodDisruptionBudgets évitent qu'une maintenance volontaire ne supprime tous les replicas d'un service critique.

## Scalabilité

Le HPA permet d'augmenter automatiquement les replicas en fonction de la consommation CPU. La démonstration se fait avec `k6` ou un pod de charge BusyBox.
