# Déploiement AKS optionnel

Ce dossier sert à montrer la trajectoire production. Le TP autorise un cluster managé Azure AKS ou un cluster local. Le rendu principal fonctionne avec kind, mais cette section montre comment le même chart Helm serait promu sur AKS.

Flux proposé:

1. Provisionner AKS avec OpenTofu/Terraform.
2. Activer Azure Container Registry ou GHCR.
3. Installer ingress-nginx, cert-manager et kube-prometheus-stack.
4. Déployer `helm/dotnetgigs` avec `environments/prod/values-prod.yaml`.

Les fichiers OpenTofu sont volontairement minimaux et documentés pour rester compatibles avec un projet étudiant.
