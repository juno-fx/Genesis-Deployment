# vars
PROJECT="genesis"

.hack/bin/cedar:
	@cargo install cedar-policy-cli --root .hack

publish-ecr:
	rm -f orion-genesis*tgz
	sed -i "s|registry:.*|registry: 709825985650.dkr.ecr.us-east-1.amazonaws.com/juno-innovations|g" values.yaml
	helm package .
	helm push orion-genesis*tgz oci://709825985650.dkr.ecr.us-east-1.amazonaws.com/juno-innovations/

format: .hack/bin/cedar
	@.hack/bin/cedar format --write -p files/rhea/policies.cedar

lint: lint-kubernetes lint-cedar lint-ansible lint-scripts

lint-ansible:
	# ansible-lint rules seem to be unable to ignore just the import - working around that..
	mkdir -p files/genesis/roles/juno-fx.juno_k3s/{tasks,meta}
	touch files/genesis/roles/juno-fx.juno_k3s/tasks/main.yml
	ansible-lint files/genesis/juno-playbook-k3s-provision.yml
lint-cedar: .hack/bin/cedar
	@.hack/bin/cedar format --check -p files/rhea/policies.cedar

lint-kubernetes:
	@.hack/lint-kube.sh

lint-scripts:
	@shellcheck .hack/*sh

# targets
cluster:
	@kind create cluster --image kindest/node:v1.30.0 --name $(PROJECT) --config juno/kind.yaml || echo "Cluster already exists..."

down:
	@kind delete cluster --name $(PROJECT)

argocd:
	@kubectl create namespace argocd || echo "Argo namespace already exists..."
	@kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@sleep 15
	@kubectl wait --namespace argocd \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/name=argocd-server \
		--timeout=90s

ingress:
	@echo "Installing NGINX Ingress..."
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@sleep 15
	@kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=90s

genesis: cluster ingress argocd
	@echo "Installing Genesis..."
	@helm upgrade -i -f .values.yaml $(PROJECT) ./
	@echo "Waiting for Genesis to settle..."
	@sleep 10
	@kubectl wait --namespace argocd \
		--for=condition=ready pod \
		--selector=app=genesis \
		--timeout=180s
	@echo "Genesis ready..."
	@kubectl get pods -n argocd
