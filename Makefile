# vars
PROJECT="genesis"

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
