# vars
PROJECT="genesis"
ECR_URL="709825985650.dkr.ecr.us-east-1.amazonaws.com/juno-innovations"
KIND_NODE_IMAGE="kindest/node:v1.30.0"
INGRESS_NGINX_URL="https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"

.hack/bin/cedar:
	@cargo install cedar-policy-cli --root .hack

publish-ecr:
	rm -f orion-genesis*tgz
	sed -i "s|registry:.*|registry: $(ECR_URL)|g" values.yaml
	sed -i "s|orion-genesis|orion-genesis-ecr|g" Chart.yaml
	sed -i 's|repository: "\(.*\)"|repository: "\1-ecr"|g' values.yaml
	helm package .
	helm push orion-genesis*tgz oci://$(ECR_URL)/

print-ecr-image-versions:
	@.hack/print-ecr-image-versions.sh

format: .hack/bin/cedar
	@.hack/bin/cedar format --write -p files/rhea/policies.cedar

lint: lint-kubernetes lint-cedar lint-ansible lint-scripts

lint-ansible:
	# ansible-lint rules seem to be unable to ignore just the import - working around that..
	mkdir -p files/genesis/roles/juno-fx.juno_k3s/{tasks,meta}
	touch files/genesis/roles/juno-fx.juno_k3s/tasks/main.yml
	ansible-lint files/genesis/juno-playbook-k3s-provision.yml
	
lint-cedar: .hack/bin/cedar
	@.hack/bin/cedar format --check -p files/rhea/system-policies.cedar
	@.hack/bin/cedar format --check -p files/rhea/user-policies.cedar

lint-kubernetes:
	@.hack/lint-kube.sh

lint-scripts:
	@shellcheck .hack/*sh

# targets
cluster:
	@kind create cluster --image $(KIND_NODE_IMAGE) --name $(PROJECT) --config juno/kind.yaml || echo "Cluster already exists..."

down:
	@kind delete cluster --name $(PROJECT) 2>/dev/null || true

argocd:
	@kubectl create namespace argocd 2>/dev/null || true
	@kubectl create -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.10.16/manifests/install.yaml
	@kubectl rollout status deployment/argocd-server \
		--namespace argocd \
		--timeout=120s

ingress:
	@echo "Installing NGINX Ingress..."
	@kubectl apply -f $(INGRESS_NGINX_URL)
	@kubectl rollout status deployment/ingress-nginx-controller \
		--namespace ingress-nginx \
		--timeout=90s

genesis: cluster ingress argocd
	@echo "Installing Genesis..."
	@helm upgrade -i -f ./values.yaml $(PROJECT) ./
	@kubectl wait --namespace argocd \
		--for=condition=ready pod \
		--selector=app=genesis \
		--timeout=180s
	@echo "Genesis ready..."
	@kubectl get pods -n argocd

# --- smoke tests ---
SMOKE_SCENARIOS = dns nohost

smoke-test-%:
	@SMOKE_SCENARIO=$* .hack/smoke-test.sh

smoke-test: $(addprefix smoke-test-,$(SMOKE_SCENARIOS))

# --- interactive tests ---
interactive-test-%:
	@SMOKE_SCENARIO=$* .hack/interactive-test.sh

interactive-test-clean:
	@docker rm -f genesis-browser 2>/dev/null || true
	@kind delete cluster --name genesis

# --- provider-pinned smoke test targets ---
smoke-test-dns-traefik:
	@INGRESS_PROVIDER=traefik SMOKE_SCENARIO=dns .hack/smoke-test.sh

smoke-test-dns-cilium:
	@INGRESS_PROVIDER=cilium SMOKE_SCENARIO=dns .hack/smoke-test.sh

smoke-test-nohost-traefik:
	@INGRESS_PROVIDER=traefik SMOKE_SCENARIO=nohost .hack/smoke-test.sh

smoke-test-nohost-cilium:
	@INGRESS_PROVIDER=cilium SMOKE_SCENARIO=nohost .hack/smoke-test.sh

# --- provider-pinned interactive test targets ---
interactive-test-dns-traefik:
	@INGRESS_PROVIDER=traefik SMOKE_SCENARIO=dns .hack/interactive-test.sh

interactive-test-dns-cilium:
	@INGRESS_PROVIDER=cilium SMOKE_SCENARIO=dns .hack/interactive-test.sh

interactive-test-nohost-traefik:
	@INGRESS_PROVIDER=traefik SMOKE_SCENARIO=nohost .hack/interactive-test.sh

interactive-test-nohost-cilium:
	@INGRESS_PROVIDER=cilium SMOKE_SCENARIO=nohost .hack/interactive-test.sh

# --- run all smoke tests sequentially (for CI) ---
SMOKE_SCENARIOS = dns nohost
INGRESS_PROVIDERS = nginx traefik cilium

smoke-test-all:
	@for scenario in $(SMOKE_SCENARIOS); do \
		for provider in $(INGRESS_PROVIDERS); do \
			echo "====== smoke-test: $$scenario / $$provider ======"; \
			INGRESS_PROVIDER=$$provider SMOKE_SCENARIO=$$scenario .hack/smoke-test.sh; \
		done; \
	done