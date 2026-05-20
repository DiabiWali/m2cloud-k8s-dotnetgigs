# ADR-002 — Exposer uniquement le frontend via Ingress

## Statut
Accepté

## Contexte
Les APIs, SQL, Redis et RabbitMQ n'ont pas besoin d'être exposés publiquement.

## Décision
Seul `webmvc` est exposé via Ingress HTTPS. Tous les autres services restent en ClusterIP.

## Conséquences
La surface d'attaque externe est réduite et les flux internes sont maîtrisés par NetworkPolicy.
