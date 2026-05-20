# Recherche Kibana — erreurs applicatives

Index pattern conseillé :

```text
m2cloud-*
```

Recherche pour un service :

```text
kubernetes.namespace_name : "m2cloud" and kubernetes.container_name : "applicants-api"
```

Recherche erreurs :

```text
kubernetes.namespace_name : "m2cloud" and (log : "ERROR" or log : "Exception" or log : " 500 ")
```

Recherche RabbitMQ :

```text
kubernetes.namespace_name : "m2cloud" and kubernetes.container_name : "rabbitmq"
```
