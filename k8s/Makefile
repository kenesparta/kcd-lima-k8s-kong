SHELL := /bin/bash

app_ns = "kcd-apps"
kong_ns = "kcd-kong"

kind-init:
	kind create cluster --name kong-kcd --config ./kind-local/clusterconfig.yml
	kubectl cluster-info --context kind-kong-kcd

install-kong:
	kubectl create ns "$(kong_ns)"
	helm install kong kong/kong -f ./kong-service/kong-conf.yaml \
		--set proxy.type=NodePort,proxy.http.nodePort=30000,proxy.tls.nodePort=30003 \
		--set ingressController.installCRDs=false \
		--set serviceMonitor.enabled=true \
		--set serviceMonitor.labels.release=promstack \
		--namespace "$(kong_ns)"

install-plugins:
	kubectl create ns "$(app_ns)"
	kubectl apply -f kong-plugins/ratelimit.yml -n "$(app_ns)"
	kubectl apply -f kong-plugins/prometheus.yml

.PHONY: apply
apply:
	kubectl apply -f service-a/hello-world.yml
