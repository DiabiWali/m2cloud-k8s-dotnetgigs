# Developer Portal — Backstage

## Objectif

Le projet intègre un portail développeur basé sur Backstage afin de transformer le cluster Kubernetes en mini plateforme applicative.

L'objectif n'est pas seulement de déployer DotNetGigs, mais de démontrer qu'une nouvelle application peut être onboardée de manière standardisée, sécurisée et industrialisée.

## Rôle de Backstage

Backstage apporte une interface centrale pour :

- cataloguer les composants applicatifs ;
- documenter les services ;
- fournir un template applicatif réutilisable ;
- générer une Pull Request GitHub ;
- relier le parcours développeur au déploiement GitOps ;
- faciliter l'onboarding d'une nouvelle application Kubernetes-ready.

## Composants visibles dans le catalogue

Le catalogue Backstage contient notamment :

- DotNetGigs ;
- SQL Data ;
- RabbitMQ Broker ;
- Redis Cache ;
- hello-api ;
- M2Cloud Kubernetes Platform ;
- Platform Team.

## Template applicatif

Le template `Nouvelle API Kubernetes-ready` permet de générer une nouvelle application avec :

- API Node.js ;
- Dockerfile ;
- Helm chart ;
- Deployment ;
- Service ;
- Ingress ;
- HPA ;
- PodDisruptionBudget ;
- ServiceMonitor ;
- manifeste Argo CD ;
- workflow GitHub Actions.

## Flux complet validé

Backstage → Software Template → Pull Request GitHub → GitHub Actions → Merge → Argo CD → Kubernetes → Application observable.

## Application témoin : hello-api

L'application `hello-api` a été générée depuis Backstage.

Elle expose :

| Endpoint | Rôle |
|---|---|
| `/health` | Vérification de disponibilité |
| `/version` | Version applicative |
| `/api/hello` | Endpoint métier de démonstration |
| `/metrics` | Métriques Prometheus minimales |

## Valeur ajoutée

Cette approche démontre une logique de Platform Engineering :

- réduction du temps d'onboarding ;
- standardisation des déploiements ;
- intégration CI/CD dès la création ;
- déploiement GitOps ;
- observabilité intégrée ;
- séparation entre expérience développeur et complexité Kubernetes.

## Limites actuelles

Dans le cadre du lab local :

- l'authentification Backstage utilise un mode simplifié ;
- l'image `hello-api:local` est chargée dans kind ;
- le registry GHCR n'est pas encore utilisé pour cette application témoin ;
- la configuration cible production nécessiterait SSO, RBAC, secrets externalisés et registry sécurisé.

## Cible production

En cible production, le portail pourrait être enrichi avec :

- authentification GitHub OAuth ou Entra ID ;
- RBAC Backstage ;
- publication d'images vers GHCR ou ACR ;
- intégration complète Argo CD ;
- TechDocs générés par CI ;
- supervision des composants depuis Backstage ;
- templates multiples : API, frontend, worker, job batch.
