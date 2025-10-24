lint: lint-ansible lint-scripts lint-kubernetes


lint-ansible:
	ansible-lint files/genesis/juno-playbook-k3s-provision.yml

lint-scripts:
	find ! -path './.devbox/*' -type f -name "*.sh" -exec shellcheck {} +
	 

# To generate  schemas use https://github.com/yannh/kubeconform openapi2jsonchema script
lint-kubernetes:
	.hack/generate-schemas.sh
	.hack/lint-kube.sh
