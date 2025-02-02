SHELL := /bin/bash

include .env
export $(shell sed 's/=.*//' .env)

app_ns = "kcd-apps"
kong_ns = "kcd-kong"
monitoring_ns = "monitoring"

.PHONY: kind-init
kind-init:
	kind create cluster --name kong-kcd --config ./kind-local/clusterconfig.yaml
	kubectl cluster-info --context kind-kong-kcd

install-kic:
	kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml
	kubectl apply -f ./kong/gateway.yaml

install-kong:
	kubectl create ns $(kong_ns)
	helm repo add kong https://charts.konghq.com
	helm repo update
	helm install kong kong/ingress -n $(kong_ns)

apps-setup:
	kubectl create ns $(app_ns)
	kubectl create secret generic cep-api-key --from-literal=key="$$API_KEY" -n $(app_ns)
	kubectl label secret cep-api-key "konghq.com/credential=key-auth" -n $(app_ns)

deploy-cep-api:
	kubectl apply -f ./apps/cep --recursive -n $(app_ns)
	kubectl annotate service cep-api konghq.com/plugins=cep-rate-limiting,key-auth -n $(app_ns)
	kubectl annotate ingress cep-api konghq.com/plugins=cep-rate-limiting,key-auth -n $(app_ns)

deploy-todo-api:
	kubectl apply -f ./apps/todo --recursive -n $(app_ns)
	kubectl annotate service todo-api konghq.com/plugins=todo-rate-limiting -n $(app_ns)
	kubectl annotate ingress todo-api konghq.com/plugins=todo-rate-limiting -n $(app_ns)

deploy-nodejs-ip-api:
	kubectl apply -f ./apps/ip --recursive -n $(app_ns)
