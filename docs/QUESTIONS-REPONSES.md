# Questions probables du professeur

## Pourquoi Helm plutôt que des YAML simples ?

Helm permet de paramétrer proprement les environnements, de versionner le déploiement, d'effectuer des rollbacks et de rendre le déploiement reproductible sur un autre cluster.

## Pourquoi seul le web est exposé ?

Parce que les APIs et composants techniques n'ont pas vocation à être accessibles depuis Internet. Le frontend devient le point d'entrée contrôlé, via Ingress HTTPS.

## Pourquoi des NetworkPolicies ?

Pour appliquer une segmentation réseau. Par défaut, les pods Kubernetes peuvent souvent communiquer librement. Ici, on documente et contrôle explicitement les flux.

## Qu'apporte Prometheus ?

Il permet de mesurer l'état du cluster, les ressources des pods, les replicas, les redémarrages et d'alerter en cas de comportement anormal.

## Comment prouves-tu le HPA ?

Je lance une charge contrôlée avec k6 ou BusyBox, puis je montre `kubectl get hpa -w` et l'évolution du nombre de replicas.

## Que ferais-tu en production ?

Je remplacerais le certificat auto-signé par cert-manager, les Secrets Kubernetes par External Secrets + Key Vault, j'utiliserais un registry privé avec scan d'images, et je déploierais sur AKS avec node pools adaptés.
