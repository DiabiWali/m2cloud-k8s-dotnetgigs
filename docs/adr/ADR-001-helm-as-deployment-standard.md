# ADR-001 — Utiliser Helm comme standard de déploiement

## Statut
Accepté

## Contexte
Le projet doit pouvoir être déployé sur un cluster vierge et potentiellement sur plusieurs environnements.

## Décision
Utiliser un chart Helm unique avec des fichiers de valeurs par environnement.

## Conséquences
Le déploiement devient reproductible, paramétrable et compatible avec les rollbacks Helm.
