# Notes de soutenance — M2Cloud Kubernetes

## Pitch d'ouverture

Notre projet consiste à industrialiser le déploiement d'une application multi-services fournie par le cours. Nous sommes partis d'un `docker-compose` qui relie une application web, trois APIs, SQL Server, Redis et RabbitMQ, puis nous avons construit une cible Kubernetes complète : conteneurisation, Helm, haute disponibilité, supervision, sécurité réseau et logs centralisés.

## Ce que nous avons fait techniquement

1. Analyse du `docker-compose` et des dépendances entre services.
2. Construction des images Docker pour chaque composant applicatif.
3. Déploiement Kubernetes avec `Deployment`, `StatefulSet`, `Service`, `Ingress`, `Secret`, `ConfigMap`, `HPA`, `NetworkPolicy`, `RBAC`.
4. Ajout des ressources CPU/mémoire/stockage, des probes et des stratégies RollingUpdate.
5. Mise en place de Prometheus/Grafana pour les métriques Kubernetes.
6. Préparation d'une stack EFK pour centraliser et rechercher les logs.
7. Automatisation via Helm et scripts shell.

## Arguments importants à défendre

### Pourquoi Helm ?

Helm permet de rendre le déploiement reproductible sur plusieurs clusters. On peut changer le registry, le tag, le domaine, les ressources ou les réplicas sans réécrire les manifests.

### Pourquoi uniquement `webmvc` est exposé ?

C'est le seul composant appelé par l'utilisateur. Les APIs, SQL Server, Redis et RabbitMQ restent internes au cluster avec des Services `ClusterIP`, ce qui réduit la surface d'exposition.

### Pourquoi des NetworkPolicies ?

Elles empêchent les flux non prévus. Par exemple, SQL Server n'accepte que les appels venant des APIs qui en ont besoin. Cela matérialise le principe du moindre privilège au niveau réseau.

### Pourquoi des probes TCP ?

L'application fournie n'expose pas forcément d'endpoint `/health` homogène. Les probes TCP valident que le port applicatif répond sans imposer une modification de code.

### Pourquoi `linux/amd64` ?

Le projet utilise .NET Core 2.1, qui est ancien. Sur Mac Apple Silicon, le build natif ARM64 peut poser problème. Le build `linux/amd64` rend le résultat plus compatible avec les images historiques.

## Démo à dérouler

```bash
kubectl get all -n m2cloud
kubectl get ingress -n m2cloud
kubectl get hpa -n m2cloud
kubectl describe deploy webmvc -n m2cloud
kubectl get networkpolicy -n m2cloud
kubectl logs deploy/webmvc -n m2cloud --tail=50
```

Puis montrer :

- `https://dotnetgigs.local`
- Grafana avec les métriques pods/nodes.
- Kibana avec une recherche sur les logs d'un service.
