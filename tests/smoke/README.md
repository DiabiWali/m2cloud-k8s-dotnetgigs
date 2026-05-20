# Smoke tests

Objectif: vérifier rapidement que le déploiement est accessible et que les composants Kubernetes sont prêts.

Commandes:

```bash
make status
make smoke
kubectl get hpa -n m2cloud
kubectl get networkpolicy -n m2cloud
```
