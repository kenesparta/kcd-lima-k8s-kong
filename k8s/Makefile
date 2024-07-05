SHELL := /bin/bash

app_ns = "kcd-apps"
kong_ns = "kcd-kong"

.PHONY: kind-init
kind-init:
	kind create cluster --name kong-kcd --config ./kind-local/clusterconfig.yml
	kubectl cluster-info --context kind-kong-kcd

install-kic:
	kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml
	kubectl apply -f kong/gateway.yaml

install-kong:
	kubectl create ns $(kong_ns)
	helm repo add kong https://charts.konghq.com \
		--set serviceMonitor.enabled=true
	helm repo update
	helm install kong kong/ingress -n $(kong_ns)

deploy-cep-api:
	kubectl create ns $(app_ns)
	kubectl apply -f ./apps/cep --recursive -n $(app_ns)

# install-kong:
#	kubectl create ns $(kong_ns)
#	helm install kong kong/kong -f ./kong-service/kong-conf.yml \
#		--set proxy.type=NodePort,proxy.http.nodePort=30000,proxy.tls.nodePort=30003 \
#		--set ingressController.installCRDs=false \
#		--set serviceMonitor.enabled=true \
#		--set serviceMonitor.labels.release=promstack \
#		--namespace $(kong_ns)

install-plugins:
	kubectl create ns $(app_ns)
	kubectl apply -f kong-plugins/ratelimit.yml -n $(app_ns)
	kubectl apply -f kong-plugins/prometheus.yml

run-services:
	# kubectl apply -f ./apps --recursive -n $(app_ns)
	# kubectl apply -f kong-ingress/hw.yml -n $(app_ns)
	kubectl apply -f kong-ingress/ingress.yml -n $(app_ns)

.PHONY: apply
apply:
	# kubectl apply -f service-a/hello-world.yml
	ls
