# Observabilité

## Prometheus / Grafana

Le repo fournit une configuration `kube-prometheus-stack` ainsi que des règles d'alerting et un dashboard Grafana JSON.

Commandes:

```bash
make observability
kubectl port-forward -n observability svc/kube-prometheus-stack-grafana 3000:80
```

Indicateurs à montrer:

- replicas disponibles par deployment;
- CPU/mémoire par pod;
- redémarrages de conteneurs;
- état des HPA;
- événements Kubernetes.

## Logs EFK

Fluent Bit collecte les logs stdout/stderr des pods et les envoie vers Elasticsearch. Kibana permet de filtrer les erreurs.

Recherche Kibana exemple:

```text
kubernetes.namespace_name : m2cloud and (log : ERROR or log : Exception or log : 500)
```

Le fichier `observability/logging/efk/kibana-dashboard.ndjson` fournit un exemple d'objet sauvegardé.
