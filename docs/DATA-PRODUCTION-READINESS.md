# Production readiness — Données

## Objectif

Ce document précise les écarts entre le lab Kubernetes local et une cible production pour les composants de données.

## Ce qui est couvert par le lab

- SQL Server en StatefulSet ;
- PVC pour la persistance SQL ;
- Job d'initialisation SQL ;
- CronJob de sauvegarde logique ;
- runbook de restauration ;
- Redis traité comme cache ;
- RabbitMQ utilisé comme broker interne ;
- preuves Kubernetes générables.

## Écarts avec une production réelle

| Sujet | Lab | Production cible |
|---|---|---|
| SQL | StatefulSet mono-réplica | Service managé ou HA |
| Backup | `.bak` sur PVC | Stockage externe chiffré |
| Secrets | Kubernetes Secret | Vault / Key Vault / External Secrets |
| RabbitMQ | Simple Deployment | Cluster persistant ou service managé |
| Redis | Cache non persistant | Cache managé ou persistant selon usage |
| Restauration | Runbook manuel | Procédure testée et planifiée |
| Monitoring | Prometheus/Grafana | Alerting et astreinte |

## Message clé

Le projet démontre la compréhension des contraintes stateful dans Kubernetes.

Le PVC assure la persistance locale, mais il ne constitue pas à lui seul une stratégie de sauvegarde. La sauvegarde, la restauration, le RPO/RTO et l'externalisation des données doivent être traités séparément.
