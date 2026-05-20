# Manifests Kubernetes bruts

Le rendu principal est le chart Helm situé dans `helm/dotnetgigs`.

Ce dossier contient des manifests bruts utiles pour correction ou démonstration rapide :

- `namespace.yaml`
- `networkpolicy.yaml`
- `rbac.yaml`

Pour générer l'ensemble des manifests depuis Helm :

```bash
helm template dotnetgigs ../../helm/dotnetgigs --namespace m2cloud > rendered.yaml
```
