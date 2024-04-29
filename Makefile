FISSION_VERSION ?= v1.20.1
FISSION_NAMESPACE := fission

.PHONY: setup
setup: setup-cluster setup-fission

.PHONY: setup-cluster
setup-cluster:
	kind create cluster --name fission-1

.PHONY: setup-fission
setup-fission: 
	kubectl create namespace $(FISSION_NAMESPACE)
	kubectl create -k "github.com/fission/fission/crds/v1?ref=$(FISSION_VERSION)"
	helm repo add fission-charts https://fission.github.io/fission-charts/
	helm repo update
	helm install --version $(FISSION_VERSION) --namespace $(FISSION_NAMESPACE) fission \
	--set serviceType=NodePort,routerServiceType=NodePort \
	fission-charts/fission-all

.PHONY: destroy-cluster
destroy-cluster:
	kind delete clusters fission-1