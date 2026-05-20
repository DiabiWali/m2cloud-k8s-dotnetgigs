# Matrice de conformité au sujet

| Critère du sujet | Implémentation | Preuve à montrer |
|---|---|---|
| Microservices orchestrés | `webmvc`, `applicants-api`, `jobs-api`, `identity-api`, `sql-data`, `rabbitmq`, `user-data` | `kubectl get deploy,svc -n m2cloud` |
| Images conteneurs | Dockerfiles dédiés | `dockerfiles/*.Dockerfile` |
| Registry privé | Variables `REGISTRY`, workflow GHCR | `.env`, `.github/workflows/build-and-push.yml` |
| Services internes | APIs, SQL, Redis, RabbitMQ en ClusterIP | `kubectl get svc -n m2cloud` |
| Exposition externe limitée | Seul `webmvc` via Ingress HTTPS | `kubectl get ingress -n m2cloud -o yaml` |
| Ressources | requests/limits CPU, mémoire, ephemeral-storage | `helm/dotnetgigs/values.yaml` |
| Affinités | Web proche des APIs, APIs proches de SQL | templates des deployments |
| HPA | Web, applicants-api, jobs-api | `kubectl get hpa -n m2cloud -w` |
| Probes | readiness/liveness | `kubectl describe pod -n m2cloud` |
| Metrics server/kube-state-metrics | kube-prometheus-stack | namespace `observability` |
| Prometheus | ServiceMonitor + rules | Grafana/Prometheus |
| HTTPS | Secret TLS auto-signé + Ingress TLS | `make tls`, `curl -k https://dotnetgigs.local` |
| RBAC | ServiceAccounts, Roles, RoleBindings | `kubectl get role,rolebinding -n m2cloud` |
| NetworkPolicy | Default deny + flux autorisés | `kubectl get netpol -n m2cloud` |
| EFK | Elasticsearch, Fluent Bit, Kibana | `observability/logging/efk/` |
| Helm complet | Chart applicatif versionné | `helm lint helm/dotnetgigs` |
| README | Procédure complète | `README.md` |
| Architecture | SVG + Mermaid | `architecture/` |
