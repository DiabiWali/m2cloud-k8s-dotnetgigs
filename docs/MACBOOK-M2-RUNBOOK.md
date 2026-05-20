# Runbook MacBook Air M2 / Colima / kind

Tu es sur Mac Apple Silicon. Le point sensible est SQL Server, qui est historiquement orienté amd64. Pour éviter les mauvaises surprises en soutenance, prépare l'environnement ainsi.

## Option recommandée pour la démo locale

```bash
colima stop
colima start --arch x86_64 --vm-type vz --vz-rosetta --cpu 6 --memory 10 --disk 60
docker context use colima
```

Puis:

```bash
make doctor
make cluster
make ingress
make bootstrap
make build
make kind-load
make tls
make deploy
```

## Si SQL Server ne démarre pas localement

Tu peux dire clairement au professeur:

> Le chart est portable Kubernetes. Le blocage éventuel local vient de l'architecture Apple Silicon et de l'image SQL Server. Pour un vrai environnement cible, je le déploie sur AKS ou sur un nœud amd64. Le chart Helm, les probes, les HPA, les secrets, les NetworkPolicies et l'Ingress restent identiques.

C'est une réponse d'architecte: tu identifies la contrainte plateforme et tu proposes une trajectoire production.
