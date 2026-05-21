SHELL := /bin/bash
-include .env
export

RELEASE_NAME ?= dotnetgigs
NAMESPACE ?= m2cloud
KIND_CLUSTER_NAME ?= m2cloud
KIND_CONFIG ?= clusters/kind/kind-config.yaml
INGRESS_HOST ?= dotnetgigs.local
REGISTRY ?= ghcr.io/example
IMAGE_TAG ?= 1.0.0

.PHONY: help doctor bootstrap cluster ingress observability build push kind-load tls deploy validate render hpa rollout-demo canary-demo evidence uninstall clean

help:
	@echo "M2Cloud Kubernetes - commandes disponibles"
	@echo "  make doctor        Vérifie les prérequis locaux"
	@echo "  make cluster       Crée un cluster kind prêt pour la démo"
	@echo "  make ingress       Installe ingress-nginx"
	@echo "  make observability Installe Prometheus/Grafana + EFK"
	@echo "  make bootstrap     Prépare le code applicatif depuis le repo du cours"
	@echo "  make build         Build les images Docker"
	@echo "  make push          Push les images vers le registry"
	@echo "  make kind-load     Charge les images dans kind"
	@echo "  make tls           Génère et installe le certificat HTTPS"
	@echo "  make deploy        Déploie le chart Helm"
	@echo "  make validate      Rend les manifests et lance les contrôles statiques"
	@echo "  make status        Affiche l'état complet du cluster"
	@echo "  make smoke         Test fonctionnel rapide"
	@echo "  make hpa           Démonstration autoscaling HPA"
	@echo "  make evidence      Collecte les preuves techniques pour la soutenance"
	@echo "  make uninstall     Supprime le déploiement"

.env:
	@cp env.example .env
	@echo "Fichier .env créé. Remplace REGISTRY et les secrets avant build/push."

doctor:
	./scripts/doctor.sh

cluster:
	./scripts/create-kind-cluster.sh

ingress:
	./scripts/install-ingress-nginx.sh

observability:
	./scripts/install-observability.sh

bootstrap:
	./scripts/bootstrap-from-upstream.sh

build:
	./scripts/build-images.sh

push:
	./scripts/push-images.sh

kind-load:
	./scripts/load-images-kind.sh

tls:
	./scripts/generate-tls-secret.sh

deploy:
	./scripts/deploy-helm.sh

validate:
	./scripts/validate.sh

render:
	./scripts/render-helm.sh

hpa:
	./scripts/test-hpa.sh

rollout-demo:
	./scripts/rolling-update-demo.sh

canary-demo:
	./scripts/canary-demo.sh

evidence:
	./scripts/collect-evidence.sh

uninstall:
	./scripts/uninstall.sh

clean:
	rm -rf _rendered _evidence charts/*.tgz

# ============================================================
# Local developer experience
# ============================================================

.PHONY: quickstart
quickstart: doctor cluster ingress bootstrap build kind-load tls observability deploy
	@echo ""
	@echo "============================================================"
	@echo "DotNetGigs est prêt."
	@echo "URL: https://dotnetgigs.local"
	@echo "Pense à ajouter 127.0.0.1 dotnetgigs.local dans le hosts Windows si besoin."
	@echo "============================================================"

.PHONY: status
status:
	./scripts/local/status.sh

.PHONY: smoke
smoke:
	curl -k -I https://dotnetgigs.local

.PHONY: proofs
proofs:
	./scripts/local/collect-proofs.sh

.PHONY: pf-argocd
pf-argocd:
	./scripts/local/pf-argocd.sh

.PHONY: pf-kibana
pf-kibana:
	./scripts/local/pf-kibana.sh

.PHONY: pf-grafana
pf-grafana:
	./scripts/local/pf-grafana.sh

.PHONY: argocd-install
argocd-install:
	kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl rollout status deployment/argocd-server -n argocd --timeout=5m

.PHONY: argocd-app
argocd-app:
	kubectl apply -f gitops/argocd/dotnetgigs-application.yaml

.PHONY: argocd-password
argocd-password:
	@kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d ; echo

.PHONY: kibana-password
kibana-password:
	@kubectl get secret -n observability elasticsearch-master-credentials -o jsonpath="{.data.password}" | base64 -d ; echo

.PHONY: grafana-password
grafana-password:
	@kubectl get secret -n observability kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
