# Démo soutenance — Backstage vers Kubernetes

## Objectif de la démo

Démontrer le flux complet d'une Internal Developer Platform :

Backstage → GitHub PR → CI/CD → Merge → Argo CD → Kubernetes → Observabilité.

## Préparation

Démarrer Backstage :

    cd developer-portal/backstage
    export GITHUB_TOKEN="$(gh auth token)"
    yarn start

URL locale :

    http://localhost:3000

## Étape 1 — Catalogue Backstage

Ouvrir `Catalog` et montrer les composants :

- DotNetGigs ;
- SQL Data ;
- RabbitMQ Broker ;
- Redis Cache ;
- hello-api.

Message oral :

> Backstage centralise le catalogue applicatif de la plateforme. Il donne une vue claire des services, de leurs owners et de leur rôle dans l'architecture.

## Étape 2 — Création d'application

Ouvrir `Create`, puis choisir :

    Nouvelle API Kubernetes-ready

Exemple de paramètres :

    Nom technique : demo-api
    Description : API générée pendant la soutenance depuis Backstage
    Owner : group:default/platform-team
    Namespace : m2cloud
    Port : 8080
    Replicas : 2
    Hostname : demo-api.dotnetgigs.local

Message oral :

> Le développeur n'a pas besoin d'écrire manuellement tous les manifests Kubernetes. Il passe par un golden path validé par la plateforme.

## Étape 3 — Pull Request GitHub

Backstage crée une Pull Request GitHub contenant :

- code applicatif ;
- Dockerfile ;
- Helm chart ;
- workflow CI ;
- manifeste Argo CD.

## Étape 4 — CI/CD

GitHub Actions valide :

- build Docker ;
- smoke tests ;
- scan Trivy ;
- Helm lint ;
- Helm template.

## Étape 5 — Argo CD

Après merge, Argo CD synchronise l'application.

Commandes de vérification :

    kubectl get application hello-api -n argocd
    kubectl get pods -n m2cloud | grep hello-api

Résultat attendu :

    hello-api   Synced   Healthy

## Étape 6 — Test applicatif

Port-forward :

    kubectl port-forward svc/hello-api -n m2cloud 8089:8080

Tests :

    curl http://localhost:8089/health
    curl http://localhost:8089/version
    curl http://localhost:8089/api/hello
    curl http://localhost:8089/metrics

## Message final

> Cette démonstration illustre une approche Platform Engineering : Backstage simplifie l'expérience développeur, GitHub assure la traçabilité et la validation CI/CD, Argo CD garantit le déploiement GitOps, et Kubernetes exécute l'application avec probes, HPA, PDB et observabilité.
