# M2Cloud Kubernetes Platform

## Objectif

Cette plateforme démontre une approche complète de déploiement cloud-native autour de Kubernetes.

Elle couvre :

- le déploiement d'une application microservices ;
- le packaging Helm ;
- le déploiement GitOps avec Argo CD ;
- l'observabilité Prometheus et Grafana ;
- la centralisation des logs avec Fluent Bit, Elasticsearch et Kibana ;
- la sécurité réseau avec Ingress, TLS, RBAC et NetworkPolicies ;
- l'orchestration des données avec StatefulSet, PVC, sauvegarde et restauration ;
- l'onboarding d'une nouvelle application via un portail développeur Backstage.

## Vision plateforme

Le projet ne vise pas uniquement à déployer une application. Il vise à construire un socle reproductible permettant d'héberger et d'industrialiser l'arrivée de nouvelles applications.

## Interfaces principales

| Interface | Usage |
|---|---|
| DotNetGigs | Application principale |
| Argo CD | Déploiement GitOps |
| Grafana | Supervision métriques |
| Kibana | Analyse des logs |
| Backstage | Portail développeur |
