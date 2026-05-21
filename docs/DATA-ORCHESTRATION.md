# Orchestration des données

## Objectif

Ce document décrit la stratégie d'orchestration des données dans la plateforme M2Cloud.

L'objectif est de montrer que le projet ne se limite pas à lancer des conteneurs applicatifs, mais couvre aussi le cycle de vie des données : persistance, initialisation, sauvegarde, restauration, supervision et limites de production.

## Composants de données

| Composant | Rôle | Type Kubernetes | Persistance | Criticité |
|---|---|---|---|---|
| SQL Server | Base relationnelle principale | StatefulSet | PVC | Critique |
| RabbitMQ | Broker de messages | Deployment dans le lab | Non persistant actuellement | Important |
| Redis | Cache applicatif | Deployment | Non persistant | Non critique |
| Secrets | Identifiants applicatifs | Secret Kubernetes | N/A | Critique |

## SQL Server

SQL Server est déployé en StatefulSet avec un PersistentVolumeClaim.

Ce choix permet de distinguer les workloads applicatifs stateless des composants de données stateful.

Le PVC permet de conserver les données au-delà du cycle de vie du pod SQL.

## Initialisation SQL

Un Job Kubernetes initialise les bases nécessaires au démarrage applicatif.

Cela permet de séparer :

- le déploiement de l'infrastructure ;
- l'initialisation des données ;
- le cycle de vie applicatif.

## Sauvegarde SQL

Un CronJob Kubernetes `sql-data-backup` déclenche une sauvegarde logique des bases SQL.

Bases sauvegardées :

- `dotnetgigs.applicants` ;
- `dotnetgigs.jobs`.

Dans le lab local, les fichiers `.bak` sont écrits dans le volume persistant SQL afin de rendre le mécanisme démontrable.

En cible production, les sauvegardes doivent être externalisées vers un stockage objet ou un service managé.

## RPO / RTO

| Indicateur | Valeur lab | Commentaire |
|---|---|---|
| RPO | 24h | Basé sur une sauvegarde quotidienne |
| RTO | Manuel documenté | Restauration via runbook |
| Fréquence backup | Quotidienne | CronJob Kubernetes |
| Rétention | Limitée dans le lab | À externaliser en production |

## Redis

Redis est traité comme un cache applicatif.

Sa perte ne doit pas entraîner de perte de données métier. Les données critiques restent portées par SQL Server.

## RabbitMQ

RabbitMQ est utilisé comme broker de messages.

Dans le lab actuel, il reste simple pour limiter la complexité. En cible production, il devrait être rendu persistant et potentiellement déployé en cluster ou remplacé par un service managé.

## Limites du lab

- SQL Server est mono-réplica.
- Les sauvegardes sont stockées localement dans le PVC SQL.
- RabbitMQ n'est pas encore persistant.
- Redis est volontairement non persistant.
- Les secrets Kubernetes natifs doivent être externalisés en production.

## Cible production

Pour une cible production, les évolutions recommandées sont :

- externalisation des sauvegardes SQL ;
- chiffrement du stockage ;
- coffre de secrets externe ;
- base managée ou architecture SQL haute disponibilité ;
- RabbitMQ persistant ou managé ;
- tests réguliers de restauration ;
- supervision des jobs de backup ;
- alerting sur échec de sauvegarde.
