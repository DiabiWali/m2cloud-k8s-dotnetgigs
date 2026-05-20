# ADR-003 — Prometheus/Grafana et EFK

## Statut
Accepté

## Contexte
Le sujet exige métriques cluster, métriques workloads, Prometheus et une stack de logs centralisée.

## Décision
Utiliser kube-prometheus-stack pour les métriques et EFK pour les logs.

## Conséquences
Le cluster est observable et les incidents peuvent être diagnostiqués avec des preuves concrètes.
