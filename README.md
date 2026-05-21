# M2Cloud Kubernetes — rendu technique niveau ingénieur / architecte

Ce dépôt est un rendu professionnel pour le projet **Conteneurisation et Orchestration**. L'objectif n'est pas seulement de lancer des pods, mais de démontrer une démarche complète: analyse des dépendances, packaging Helm, sécurité réseau, haute disponibilité, scalabilité, observabilité, logs centralisés, automatisation et exploitation.

## Positionnement du rendu

Le sujet demande le déploiement de plusieurs microservices REST et applications web dans Kubernetes afin d'assurer la haute disponibilité des applications. Les services à orchestrer sont `web`, `applicants.api`, `identity.api`, `jobs.api`, `sql.data` et `rabbitmq`.

Ce repo apporte une réponse structurée autour de trois axes:

1. **Build & packaging**: Dockerfiles, tagging d'images, registry privé, chart Helm versionné.
2. **Run Kubernetes**: Deployments, Services, Ingress HTTPS, HPA, probes, resources, RBAC, NetworkPolicy, PDB.
3. **Operate**: Prometheus/Grafana, EFK, runbooks, tests de charge, démonstration HPA, CI/CD et matrice de conformité.

## Démarrage rapide local

Ce dépôt permet de déployer l’application DotNetGigs sur un cluster Kubernetes local `kind`.

### Depuis zéro

```bash
git clone https://github.com/DiabiWali/m2cloud-k8s-dotnetgigs.git
cd m2cloud-k8s-dotnetgigs
cp env.example .env
make quickstart
```

Ajouter l’entrée DNS locale.

Sous Linux / WSL :

```bash
echo "127.0.0.1 dotnetgigs.local" | sudo tee -a /etc/hosts
```

Sous Windows, ajouter dans :

```text
C:\Windows\System32\drivers\etc\hosts
```

la ligne :

```text
127.0.0.1 dotnetgigs.local
```

Tester l’application :

```bash
make smoke
```

URL applicative :

```text
https://dotnetgigs.local
```

---

## Redémarrage après extinction du PC

Après redémarrage de la machine, il n’est généralement pas nécessaire de tout redéployer si Docker Desktop / kind a conservé les conteneurs.

Vérifier l’état :

```bash
cd ~/projects/m2cloud-k8s-architecte
make status
```

Si les pods sont toujours `Running`, relancer uniquement les interfaces web souhaitées.

---

## Interfaces web

Le projet expose plusieurs interfaces web pour piloter, superviser et diagnostiquer la plateforme Kubernetes.

### Argo CD

Argo CD permet de piloter le déploiement GitOps de l’application DotNetGigs depuis une interface web.

```bash
make pf-argocd
```

URL :

```text
https://localhost:8080
```

Utilisateur :

```text
admin
```

Mot de passe :

```bash
make argocd-password
```

Argo CD compare l’état déclaré dans GitHub avec l’état réel du cluster Kubernetes. L’objectif est d’avoir l’application en état :

```text
Healthy / Synced
```

### Kibana

Kibana permet d’explorer les logs collectés par Fluent Bit et stockés dans Elasticsearch.

```bash
make pf-kibana
```

URL :

```text
http://localhost:5601
```

Utilisateur :

```text
elastic
```

Mot de passe :

```bash
make kibana-password
```

Data View recommandée :

```text
Name: Kubernetes Logs
Index pattern: fluent-bit*
Timestamp field: @timestamp
```

Kibana permet de filtrer les logs par namespace, pod, conteneur ou message d’erreur.

Exemples de filtres :

```text
kubernetes.namespace_name : "m2cloud"
```

```text
kubernetes.container_name : "webmvc"
```

```text
kubernetes.container_name : "jobs-api"
```

### Grafana

Grafana permet de visualiser les métriques collectées par Prometheus.

```bash
make pf-grafana
```

URL :

```text
http://localhost:3000
```

Utilisateur :

```text
admin
```

Mot de passe :

```bash
make grafana-password
```

Grafana est utilisé pour suivre l’état du cluster, des pods, des ressources CPU/mémoire et des composants Kubernetes.

---

## Commandes utiles

État global de la plateforme :

```bash
make status
```

Test HTTP de l’application :

```bash
make smoke
```

Génération des preuves techniques :

```bash
make proofs
```

Installation et accès Argo CD :

```bash
make argocd-install
make argocd-app
make pf-argocd
```

---

## Chaîne d’exploitation

Déploiement applicatif :

```text
GitHub
  -> Argo CD
  -> Helm
  -> Kubernetes kind
  -> DotNetGigs
```

Observabilité métriques :

```text
Pods / Nodes
  -> Prometheus
  -> Grafana
```

Observabilité logs :

```text
Pods Kubernetes
  -> Fluent Bit
  -> Elasticsearch
  -> Kibana
```

---

## Points d’attention

Les images utilisées en local sont chargées dans le cluster kind avec :

```bash
make build
make kind-load
```

Tant que les images utilisent le registre local :

```text
local/m2cloud
```

un nouveau cluster devra reconstruire et recharger les images.

Une évolution possible est de publier les images dans GitHub Container Registry :

```text
ghcr.io/diabiwali/...
```

puis de laisser Argo CD déployer directement depuis les images publiées.
