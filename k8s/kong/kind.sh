#!/bin/bash
kind create cluster --name kong-kcd --config clusterconfig.yaml
kubectl cluster-info --context kind-kong-kcd
