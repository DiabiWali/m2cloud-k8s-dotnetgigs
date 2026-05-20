# M2Cloud Kubernetes — rendu technique niveau ingénieur / architecte

Ce dépôt est un rendu professionnel pour le projet **Conteneurisation et Orchestration**. L'objectif n'est pas seulement de lancer des pods, mais de démontrer une démarche complète: analyse des dépendances, packaging Helm, sécurité réseau, haute disponibilité, scalabilité, observabilité, logs centralisés, automatisation et exploitation.

## Positionnement du rendu

Le sujet demande le déploiement de plusieurs microservices REST et applications web dans Kubernetes afin d'assurer la haute disponibilité des applications. Les services à orchestrer sont `web`, `applicants.api`, `identity.api`, `jobs.api`, `sql.data` et `rabbitmq`.

Ce repo apporte une réponse structurée autour de trois axes:

1. **Build & packaging**: Dockerfiles, tagging d'images, registry privé, chart Helm versionné.
2. **Run Kubernetes**: Deployments, Services, Ingress HTTPS, HPA, probes, resources, RBAC, NetworkPolicy, PDB.
3. **Operate**: Prometheus/Grafana, EFK, runbooks, tests de charge, démonstration HPA, CI/CD et matrice de conformité.

## Démarrage rapide local avec kind

```bash
cp env.example .env
nano .env

make doctor
make cluster
make ingress
make bootstrap
make build
make kind-load
make tls
make deploy
make status
make smoke
```

Ajoute l'entrée locale DNS si besoin:

```bash
echo "127.0.0.1 dotnetgigs.local" | sudo tee -a /etc/hosts
```

Accès applicatif:

```text
https://dotnetgigs.local
```

## Démonstration attendue en soutenance

```bash
make status      # état général du cluster
make smoke       # test HTTPS
make hpa         # montée en charge et autoscaling
make evidence    # collecte des preuves techniques
```

Pour l'observabilité:

```bash
make observability
kubectl port-forward -n observability svc/kube-prometheus-stack-grafana 3000:80
```

Puis ouvrir `http://localhost:3000`.

## Structure du dépôt

```text
.
├── dockerfiles/                 # Dockerfiles multi-stage par service
├── helm/dotnetgigs/             # Chart Helm complet de l'application
├── environments/                # Valeurs dev/prod
├── clusters/kind/               # Cluster local reproductible
├── infra/opentofu/aks/          # Trajectoire cloud AKS optionnelle
├── observability/               # Prometheus, Grafana, EFK
├── policies/                    # Politiques Kyverno de gouvernance Kubernetes
├── scripts/                     # Automatisation build/deploy/test/evidence
├── tests/                       # Charge k6 et smoke tests
├── architecture/                # Schémas C4, Mermaid et SVG
└── docs/                        # Runbooks, ADR, sécurité, soutenance
```

## Matrice de conformité rapide

| Exigence | Réponse dans ce repo |
|---|---|
| Dockerfiles par service | `dockerfiles/*.Dockerfile` |
| Kubernetes / Helm | `helm/dotnetgigs/templates/*` |
| Chart Helm complet | `helm/dotnetgigs/Chart.yaml`, `values.yaml`, `templates/` |
| HTTPS externe | `templates/ingress.yaml`, `scripts/generate-tls-secret.sh` |
| HPA | `templates/hpa.yaml`, `scripts/test-hpa.sh`, `tests/load/k6-hpa.js` |
| Probes santé | Deployments applicatifs du chart Helm |
| Ressources CPU/MEM/disque | `helm/dotnetgigs/values.yaml` |
| RBAC | `templates/serviceaccounts-rbac.yaml` |
| NetworkPolicy | `templates/networkpolicy.yaml` |
| Prometheus / métriques | `observability/prometheus/*`, `templates/servicemonitor.yaml` |
| EFK / logs | `observability/logging/efk/*` |
| Schéma architecture | `architecture/architecture.svg`, `architecture/c4-container.mmd` |
| Déploiement automatisé | `Makefile`, `scripts/*`, `.github/workflows/*` |
| Documentation soutenance | `docs/DEMO-SOUTENANCE.md`, `docs/QUESTIONS-REPONSES.md` |

## Choix d'architecture

Le service `webmvc` est le seul exposé publiquement via Ingress HTTPS. Les APIs et les composants techniques restent en `ClusterIP`. Les flux sont restreints avec NetworkPolicy: le web appelle les APIs, les APIs accèdent à SQL/RabbitMQ, et `identity-api` accède à Redis `user-data`.

Le chart sépare les paramètres applicatifs en ConfigMap et les données sensibles en Secret. Les workloads applicatifs disposent de probes, resources, RollingUpdate et PodDisruptionBudget. L'autoscaling est activé sur `webmvc`, `applicants-api` et `jobs-api`.

## Note MacBook Apple Silicon

SQL Server container est un point sensible sur Apple Silicon. Pour une démo locale fiable, utilise Colima en mode x86_64/Rosetta ou fais la démonstration sur AKS. Le runbook dédié est dans `docs/MACBOOK-M2-RUNBOOK.md`.

## Validation CI/CD

Le workflow GitHub Actions exécute:

- lint Helm;
- rendu Helm;
- validation Kubernetes avec kubeconform;
- scan IaC avec Trivy;
- workflow optionnel de build/push vers GHCR.

## Commande de rendu au professeur

Le mail et le sujet proposés sont prêts dans `docs/MAIL-RENDU.md`.
