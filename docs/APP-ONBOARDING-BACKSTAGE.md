# Onboarding applicatif avec Backstage

## Objectif

Ce document décrit le parcours d'ajout d'une nouvelle application dans la plateforme M2Cloud à partir du portail développeur Backstage.

## Parcours utilisateur

1. Le développeur ouvre Backstage.
2. Il clique sur `Create`.
3. Il choisit le template `Nouvelle API Kubernetes-ready`.
4. Il renseigne les paramètres de l'application.
5. Backstage génère le squelette applicatif.
6. Backstage crée une Pull Request GitHub.
7. GitHub Actions valide le build, le smoke test, le scan et Helm.
8. La Pull Request est mergée.
9. Argo CD synchronise l'application dans Kubernetes.
10. L'application est accessible et observable.

## Paramètres demandés

| Paramètre | Exemple | Description |
|---|---|---|
| Nom technique | `hello-api` | Nom Kubernetes-compatible |
| Description | API de démonstration | Description courte |
| Owner | `group:default/platform-team` | Responsable Backstage |
| Namespace | `m2cloud` | Namespace cible |
| Port | `8080` | Port applicatif |
| Replicas | `2` | Nombre de pods |
| Hostname | `hello-api.dotnetgigs.local` | Host Ingress |

## Fichiers générés

Le template génère :

- `apps/<app-name>/Dockerfile`
- `apps/<app-name>/README.md`
- `apps/<app-name>/catalog-info.yaml`
- `apps/<app-name>/package.json`
- `apps/<app-name>/src/server.js`
- `apps/<app-name>/helm/Chart.yaml`
- `apps/<app-name>/helm/values.yaml`
- `apps/<app-name>/helm/templates/deployment.yaml`
- `apps/<app-name>/helm/templates/service.yaml`
- `apps/<app-name>/helm/templates/ingress.yaml`
- `apps/<app-name>/helm/templates/hpa.yaml`
- `apps/<app-name>/helm/templates/pdb.yaml`
- `apps/<app-name>/helm/templates/servicemonitor.yaml`
- `gitops/apps/<app-name>-application.yaml`
- `.github/workflows/<app-name>-ci.yaml`

## Contrôles CI/CD

Le workflow GitHub Actions exécute :

- build de l'image Docker ;
- smoke test des endpoints ;
- scan Trivy ;
- lint Helm ;
- rendu Helm template.

## Contrôles Kubernetes

L'application générée contient :

- Deployment ;
- Service ClusterIP ;
- Ingress ;
- HPA ;
- PodDisruptionBudget ;
- ServiceMonitor ;
- probes `/health`.

## Intérêt pour la soutenance

Ce module montre que le projet ne se limite pas à déployer une application existante.

Il démontre la capacité à construire une plateforme permettant d'accueillir de nouvelles applications de manière reproductible, standardisée et sécurisée.
