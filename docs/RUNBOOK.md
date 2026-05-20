# Runbook exploitation

## Vérifier l'état global

```bash
make status
kubectl get events -n m2cloud --sort-by=.lastTimestamp | tail -50
```

## Diagnostiquer un service indisponible

```bash
kubectl get pods -n m2cloud -o wide
kubectl describe pod -n m2cloud <pod>
kubectl logs -n m2cloud deploy/webmvc --tail=100
```

## Vérifier l'Ingress HTTPS

```bash
kubectl get ingress -n m2cloud
kubectl describe ingress -n m2cloud dotnetgigs
curl -k -I https://dotnetgigs.local
```

## Vérifier les HPA

```bash
kubectl get hpa -n m2cloud -w
kubectl top pods -n m2cloud
```

## Rollback Helm

```bash
helm history dotnetgigs -n m2cloud
helm rollback dotnetgigs <REVISION> -n m2cloud
```

## Collecte de preuves

```bash
make evidence
```
