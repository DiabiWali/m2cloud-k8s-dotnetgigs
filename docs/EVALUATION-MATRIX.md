# Matrice d'évaluation — Projet M2Cloud Kubernetes DotNetGigs

## Objectif

Cette matrice relie les attendus d'un projet de conteneurisation et d'orchestration niveau ingénieur aux éléments réellement implémentés dans le dépôt.

Elle sert de support de soutenance pour démontrer que le projet ne se limite pas à un déploiement applicatif, mais couvre aussi l'exploitation, la sécurité, l'observabilité, le GitOps, l'orchestration des données et l'onboarding applicatif via un portail développeur.

## Synthèse

| Domaine | Niveau atteint | Commentaire |
|---|---|---|
| Conteneurisation | Validé | Images Docker, Dockerfiles, build local et CI |
| Orchestration Kubernetes | Validé | Deployments, StatefulSet, Services, Ingress, HPA, PDB |
| Packaging Helm | Validé | Chart principal DotNetGigs et chart hello-api |
| GitOps | Validé | Argo CD pour DotNetGigs et hello-api |
| CI/CD | Validé | GitHub Actions, build, scan, smoke tests, Helm lint |
| Observabilité | Validé | Prometheus, Grafana, ServiceMonitor, PrometheusRule |
| Logs centralisés | Validé | Fluent Bit, Elasticsearch, Kibana |
| Sécurité Kubernetes | Validé | TLS, NetworkPolicies, RBAC, Secrets, PodSecurity/Kyverno |
| Orchestration des données | Validé | SQL StatefulSet, PVC, Job init, CronJob backup, runbook restore |
| Developer Platform | Validé | Backstage Catalog, template, Pull Request GitHub, onboarding hello-api |
| Production readiness | Partiellement validé | Limites documentées et trajectoire production définie |

## Matrice détaillée

| Critère évalué | Implémentation dans le projet | Preuves / commandes | Fichiers associés | Statut |
|---|---|---|---|---|
| Conteneurisation des services | Les services DotNetGigs sont conteneurisés avec Docker. Une application témoin `hello-api` est également générée avec Dockerfile. | `docker build`, GitHub Actions, smoke tests hello-api | `dockerfiles/`, `apps/hello-api/Dockerfile`, `.github/workflows/hello-api-ci.yaml` | Validé |
| Architecture microservices | L'application repose sur plusieurs composants : WebMVC, APIs, SQL Server, Redis, RabbitMQ. | `kubectl get deploy,svc -n m2cloud` | `helm/dotnetgigs/templates/` | Validé |
| Orchestration Kubernetes | Les composants applicatifs sont déployés avec Deployments, Services, Ingress, HPA et PDB. SQL Server est géré en StatefulSet. | `kubectl get all -n m2cloud`, `kubectl get statefulset -n m2cloud` | `helm/dotnetgigs/templates/*.yaml` | Validé |
| Packaging Helm | Le déploiement principal est packagé via Helm. L'application `hello-api` générée par Backstage possède aussi son propre chart Helm. | `helm lint helm/dotnetgigs`, `helm lint apps/hello-api/helm` | `helm/dotnetgigs/`, `apps/hello-api/helm/` | Validé |
| Exposition applicative | Le frontend DotNetGigs est exposé via Ingress HTTPS. `hello-api` dispose également d'un Ingress généré. | `kubectl get ingress -n m2cloud` | `helm/dotnetgigs/templates/ingress.yaml`, `apps/hello-api/helm/templates/ingress.yaml` | Validé |
| Haute disponibilité applicative | Les services applicatifs critiques disposent de plusieurs replicas. Les PDB limitent les interruptions volontaires. | `kubectl get deploy,pdb -n m2cloud` | `helm/dotnetgigs/templates/pdb.yaml`, `apps/hello-api/helm/templates/pdb.yaml` | Validé |
| Health checks Kubernetes | Les workloads disposent de readiness/liveness probes pour permettre à Kubernetes de détecter l'état des services. | `kubectl describe deploy -n m2cloud` | Templates Helm applicatifs | Validé |
| Autoscaling | Les composants applicatifs disposent de HPA. `hello-api` est également générée avec HPA. | `kubectl get hpa -n m2cloud` | `helm/dotnetgigs/templates/hpa.yaml`, `apps/hello-api/helm/templates/hpa.yaml` | Validé |
| Sécurité réseau | Une politique default-deny ingress est appliquée. Les flux autorisés sont explicitement définis, notamment vers SQL, Redis et RabbitMQ. | `kubectl get networkpolicy -n m2cloud` | `helm/dotnetgigs/templates/networkpolicy.yaml` | Validé |
| Sécurisation des flux internes | Les services internes restent en ClusterIP. Les APIs, SQL, Redis et RabbitMQ ne sont pas exposés publiquement. | `kubectl get svc -n m2cloud` | Templates Services Helm | Validé |
| TLS / HTTPS | L'accès applicatif principal est prévu en HTTPS via Ingress et secret TLS. | `kubectl get ingress,secret -n m2cloud` | `scripts/generate-tls-secret.sh`, `helm/dotnetgigs/templates/ingress.yaml` | Validé |
| RBAC / ServiceAccounts | Le projet intègre des éléments RBAC et limite l'automount du token sur plusieurs workloads. | `kubectl get sa,role,rolebinding -n m2cloud` | `helm/dotnetgigs/templates/rbac.yaml` | Validé |
| Secrets Kubernetes | Les mots de passe SQL et RabbitMQ sont injectés via Secret Kubernetes. | `kubectl get secret -n m2cloud` | `helm/dotnetgigs/templates/secret.yaml` | Validé pour lab |
| PodSecurity / Kyverno | Le projet intègre des labels PodSecurity et des politiques Kyverno en mode contrôle/audit. | `kubectl get policy -A`, `kubectl get ns m2cloud -o yaml` | `policies/kyverno/`, `helm/dotnetgigs/templates/namespace.yaml` | Validé |
| Observabilité métriques | Prometheus/Grafana sont installés. Des ServiceMonitor et PrometheusRule sont présents. | `kubectl get servicemonitor,prometheusrule -A` | `observability/`, `helm/dotnetgigs/templates/servicemonitor.yaml` | Validé |
| Logs centralisés | Les logs sont collectés via Fluent Bit et consultables dans Kibana/Elasticsearch. | `kubectl logs -n observability daemonset/fluent-bit`, Kibana | `observability/efk/`, `scripts/install-observability.sh` | Validé |
| GitOps DotNetGigs | DotNetGigs est piloté par une Application Argo CD. | `kubectl get application -n argocd` | `gitops/argocd/dotnetgigs-application.yaml` | Validé |
| GitOps hello-api | L'application `hello-api` générée par Backstage est synchronisée par Argo CD. | `kubectl get application hello-api -n argocd` | `gitops/apps/hello-api-application.yaml` | Validé |
| CI/CD principal | Le dépôt contient une CI de validation avec contrôles statiques, Helm et sécurité. | GitHub Actions | `.github/workflows/` | Validé |
| CI/CD application générée | `hello-api` dispose d'une CI dédiée avec build Docker, smoke tests, scan Trivy, Helm lint et Helm template. | `gh pr checks`, GitHub Actions | `.github/workflows/hello-api-ci.yaml` | Validé |
| Orchestration des données — SQL | SQL Server est déployé en StatefulSet avec PVC pour gérer la persistance. | `kubectl get statefulset,pvc -n m2cloud` | `helm/dotnetgigs/templates/sql-data.yaml`, `proofs/18-data-statefulsets.txt`, `proofs/19-data-pvc.txt` | Validé |
| Initialisation des données | Un Job Kubernetes initialise les bases nécessaires au démarrage applicatif. | `kubectl get job -n m2cloud`, `kubectl logs job/...` | `helm/dotnetgigs/templates/sql-init-job.yaml` | Validé |
| Sauvegarde SQL | Un CronJob Kubernetes `sql-data-backup` déclenche une sauvegarde logique des bases SQL. | `kubectl get cronjob,job -n m2cloud` | `helm/dotnetgigs/templates/sql-backup-cronjob.yaml`, `proofs/20-data-jobs-cronjobs.txt` | Validé |
| Preuve de backup | Les fichiers `.bak` sont générés dans le volume SQL pour les bases `dotnetgigs.applicants` et `dotnetgigs.jobs`. | `make data-backup-demo`, `cat proofs/23-sql-backup-files.txt` | `scripts/local/data-backup-demo.sh`, `proofs/23-sql-backup-files.txt` | Validé |
| Runbook restauration | Une procédure de restauration SQL est documentée avec points de vigilance RPO/RTO. | Lecture runbook | `docs/DATA-RESTORE-RUNBOOK.md` | Validé |
| RPO / RTO | Le lab documente un RPO de 24h basé sur sauvegarde quotidienne et un RTO manuel documenté. | Documentation | `docs/DATA-ORCHESTRATION.md`, `docs/DATA-PRODUCTION-READINESS.md` | Validé |
| Redis cache | Redis est traité comme cache non critique. Sa perte ne doit pas entraîner de perte métier. | `kubectl get deploy,svc -n m2cloud | grep user-data` | `helm/dotnetgigs/templates/redis.yaml`, `docs/DATA-ORCHESTRATION.md` | Validé |
| RabbitMQ broker | RabbitMQ est intégré comme broker interne. Sa trajectoire production est documentée. | `kubectl get deploy,svc -n m2cloud | grep rabbitmq` | `helm/dotnetgigs/templates/rabbitmq.yaml`, `docs/DATA-ORCHESTRATION.md` | Validé avec limite assumée |
| Developer Portal Backstage | Backstage est ajouté comme portail développeur avec catalogue applicatif. | Interface Backstage, Catalog | `developer-portal/backstage/`, `docs/DEVELOPER-PORTAL.md` | Validé |
| Catalogue applicatif | Backstage catalogue DotNetGigs, SQL Data, RabbitMQ, Redis, hello-api et la plateforme M2Cloud. | Backstage Catalog | `developer-portal/backstage/catalog/m2cloud/catalog-info.yaml`, `apps/hello-api/catalog-info.yaml` | Validé |
| Template applicatif | Backstage fournit un template `Nouvelle API Kubernetes-ready`. | Backstage Create | `developer-portal/backstage/templates/kubernetes-api/template.yaml` | Validé |
| Pull Request automatisée | Le template Backstage génère une Pull Request GitHub pour intégrer une nouvelle application. | PR GitHub hello-api | `docs/APP-ONBOARDING-BACKSTAGE.md`, `docs/BACKSTAGE-DEMO-FLOW.md` | Validé |
| Onboarding hello-api | `hello-api` a été générée depuis Backstage avec Dockerfile, Helm chart, GitOps et CI. | `apps/hello-api/`, GitHub Actions, Argo CD | `apps/hello-api/`, `.github/workflows/hello-api-ci.yaml`, `gitops/apps/hello-api-application.yaml` | Validé |
| Automatisation de démo | Un script permet d'automatiser le flux Backstage vers GitHub, Argo CD et Kubernetes. | `make demo-backstage-flow APP_NAME=...` | `scripts/local/demo-backstage-flow.sh`, `Makefile` | Validé |
| Preuves techniques | Les preuves Kubernetes, observabilité, GitOps et données sont collectées automatiquement. | `make proofs` | `scripts/local/collect-proofs.sh`, `proofs/`, `proofs-m2cloud-k8s.tar.gz` | Validé |
| Runbooks | Le projet documente les procédures utiles pour exploiter, restaurer et démontrer la plateforme. | Lecture docs | `docs/`, `README.md` | Validé |
| Production readiness | Les limites du lab sont explicitées : secrets, stockage, sauvegarde externe, services managés, HA. | Documentation | `docs/DATA-PRODUCTION-READINESS.md`, `docs/DEVELOPER-PORTAL.md` | Validé |
| Infrastructure as Code cible | Le dépôt contient une structure OpenTofu/AKS pour projeter la cible cloud managée. | Lecture infra | `infra/opentofu/aks/` | Bonus |
| Soutenance guidée | Le dépôt fournit des docs de démonstration, des preuves et des captures exploitables dans un support Gamma/PowerPoint. | `docs/`, `proofs/`, `ppt-captures/` | `docs/DEMO-SOUTENANCE.md`, `docs/BACKSTAGE-DEMO-FLOW.md`, `ppt-captures/` | Validé |

## Lecture recommandée pour le jury

| Sujet | Document |
|---|---|
| Vue générale du projet | `README.md` |
| Démo de soutenance | `docs/DEMO-SOUTENANCE.md` |
| Portail développeur | `docs/DEVELOPER-PORTAL.md` |
| Onboarding applicatif | `docs/APP-ONBOARDING-BACKSTAGE.md` |
| Démo Backstage vers Kubernetes | `docs/BACKSTAGE-DEMO-FLOW.md` |
| Orchestration des données | `docs/DATA-ORCHESTRATION.md` |
| Restauration SQL | `docs/DATA-RESTORE-RUNBOOK.md` |
| Production readiness données | `docs/DATA-PRODUCTION-READINESS.md` |
| Sécurité | `docs/SECURITY.md` |
| Preuves techniques | `proofs/` et `proofs-m2cloud-k8s.tar.gz` |

## Points forts à défendre à l'oral

1. Le projet couvre un vrai cycle DevOps : build, validation, déploiement, supervision et preuves.
2. Kubernetes est utilisé comme plateforme d'exécution, pas seulement comme outil de lancement de pods.
3. Les données sont traitées comme des composants stateful avec persistance, initialisation, sauvegarde et restauration.
4. Backstage transforme le projet en mini Internal Developer Platform.
5. Argo CD garantit le déploiement GitOps et la détection d'écart.
6. Les limites de production sont assumées et documentées.

## Limites assumées

| Limite | Justification | Évolution cible |
|---|---|---|
| Cluster local kind | Environnement pédagogique et démonstrable | AKS ou cluster managé |
| Secrets Kubernetes natifs | Acceptable pour lab | External Secrets + coffre de secrets |
| SQL mono-réplica | Suffisant pour démontrer StatefulSet/PVC | SQL managé ou HA |
| Backups stockés dans PVC | Démontrable localement | Stockage objet externe chiffré |
| RabbitMQ non persistant | Limitation assumée du lab | RabbitMQ cluster/operator ou service managé |
| Auth Backstage simplifiée | Suffisante pour soutenance locale | SSO GitHub OAuth ou Entra ID |
| Image hello-api locale | Démo kind | GHCR/ACR avec imagePullSecrets |

## Conclusion

Le projet démontre une approche complète de plateforme cloud-native :

- application microservices conteneurisée ;
- orchestration Kubernetes ;
- packaging Helm ;
- sécurité réseau ;
- observabilité ;
- logs centralisés ;
- GitOps ;
- CI/CD ;
- orchestration des données ;
- portail développeur Backstage ;
- preuves et runbooks.

Cette couverture permet de défendre un niveau ingénieur / architecte sur un sujet de conteneurisation et orchestration.
