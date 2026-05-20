# Sécurité Kubernetes

## Mesures mises en place

- Exposition externe limitée au frontend via Ingress HTTPS.
- TLS auto-signé pour la soutenance, remplaçable par cert-manager en production.
- NetworkPolicy en mode default-deny ingress.
- ServiceAccounts dédiés et automount désactivé quand le token Kubernetes n'est pas nécessaire.
- RBAC minimal pour les workloads qui doivent interagir avec l'API Kubernetes.
- Secrets Kubernetes pour SQL et RabbitMQ.
- PodSecurity labels sur le namespace.
- Politiques Kyverno fournies en audit: resources/probes obligatoires, interdiction du tag `latest`.

## Risques résiduels assumés pour le TP

- Les images .NET Core 2.1 sont legacy si l'application upstream l'impose. En production, migration vers une version supportée.
- Le Secret Kubernetes n'est pas chiffré côté applicatif. En production: Azure Key Vault + External Secrets Operator.
- Le certificat est auto-signé. En production: cert-manager + ACME ou certificat d'entreprise.
- SQL Server local peut nécessiter une architecture x86_64 sur Mac Apple Silicon.
