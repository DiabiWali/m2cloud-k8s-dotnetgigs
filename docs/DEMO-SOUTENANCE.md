# Script de soutenance — 20 minutes

## 1. Contexte et objectif — 2 min

Le sujet consiste à conteneuriser et orchestrer plusieurs microservices dans Kubernetes, avec haute disponibilité, sécurité, observabilité et automatisation. Mon objectif a été de traiter le TP comme une mini mise en production.

## 2. Architecture — 4 min

Présenter `architecture/architecture.svg`.

Message clé:

> Seul le frontend est exposé en HTTPS. Les APIs, SQL, RabbitMQ et Redis restent internes au cluster. Les communications sont limitées par NetworkPolicy.

## 3. Déploiement Helm — 4 min

Commandes:

```bash
helm lint helm/dotnetgigs -f environments/dev/values-dev.yaml
helm upgrade --install dotnetgigs helm/dotnetgigs -n m2cloud --create-namespace -f helm/dotnetgigs/values.yaml -f environments/dev/values-dev.yaml
kubectl get all -n m2cloud
```

## 4. Sécurité — 3 min

Montrer:

```bash
kubectl get ingress,secret,networkpolicy,role,rolebinding -n m2cloud
```

Expliquer TLS, RBAC, Secrets, default deny.

## 5. Scalabilité et santé — 3 min

Montrer:

```bash
kubectl get hpa -n m2cloud
make hpa
kubectl describe deploy webmvc -n m2cloud
```

## 6. Observabilité et logs — 3 min

Montrer Prometheus/Grafana, puis la recherche Kibana sur les erreurs.

## 7. Conclusion — 1 min

> Le rendu ne se limite pas à déployer l'application. Il fournit une base industrialisable: Helm, CI, sécurité, observabilité, runbooks et preuves d'exploitation.
