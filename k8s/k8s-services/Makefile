apply:
	kubectl apply -f service-a/hello-world.yml

install-kong:
	helm repo add kong https://charts.konghq.com
	helm repo update
	helm install kong/kong --generate-name --set ingressController.installCRDs=false

apply-ingress:
	kubectl create secret generic kong-enterprise-superuser-password \
		-n default \
		--from-literal=password=your-password
	kubectl create -f ingress.yml