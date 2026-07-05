# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kubernetes cluster infrastructure project demonstrating the **API Gateway pattern** using **Kong** on K8s. Three
microservices (CEP API, Todo API, IP API) are deployed behind Kong with authentication and rate limiting. Supports both
local development via KIND and cloud deployment via Terraform on Google Cloud GKE.

## Architecture

Two deployment paths share the same K8s manifests:

- **Local**: KIND cluster (1 control-plane + 3 workers) → Kong Ingress Controller → microservices
- **Cloud**: Terraform provisions GKE cluster on Google Cloud → same K8s manifests applied

Kong acts as the API gateway, handling routing, key-auth authentication, and rate limiting via KongPlugin CRDs. All apps
deploy to the `kcd-apps` namespace; Kong lives in `kcd-kong`.

### Deployed Services

| Service                | Image                       | Port | Route  | Auth                           |
|------------------------|-----------------------------|------|--------|--------------------------------|
| CEP API (postal codes) | `kenesparta/cep-api`        | 8080 | `/cep` | Key-auth + rate limit (50/min) |
| Todo API (Rust)        | `kenesparta/rs-simple-todo` | 8754 | `/td`  | Rate limit (1/sec)             |
| IP API (Node.js)       | `kenesparta/nodejs-ip`      | 3000 | `/ip`  | None                           |

## Common Commands

### Local Kubernetes (KIND)

All commands run from `k8s/` directory using `make`. Requires a `.env` file (see `k8s/.env.example`).

```bash
# Full local setup sequence:
make kind-init        # Create KIND cluster
make install-kic      # Install Kong Ingress Controller with Gateway API CRDs
make install-kong     # Deploy Kong via Helm
make apps-setup       # Create namespaces and API key secrets
make deploy-cep-api   # Deploy CEP API (with auth + rate limit)
make deploy-todo-api  # Deploy Todo API (with rate limit)
make deploy-nodejs-ip-api  # Deploy IP API
```

### Terraform (Google Cloud)

All commands run from `terraform/` directory. Requires a `.env` file (see `terraform/.env.example`).

```bash
make dev/init     # Initialize Terraform with GCS backend
make dev/plan     # Plan infrastructure changes
make dev/apply    # Apply infrastructure
make dev/destroy  # Tear down infrastructure
```

Terraform manages only Google Cloud infrastructure (cluster, node pool, network) — there is no Kubernetes provider.
After `dev/apply`, point kubectl at the cluster with
`gcloud container clusters get-credentials kcd-main-cluster --zone us-central1-c --project kdc-lima`, then install Kong
and the apps using the `k8s/` make targets (skip `kind-init`).

### Integration/Load Tests

Go-based tests in `tests/`. Requires a `.env` file (see `tests/.env.example`) with `EXTERNAL_IP` and `API_KEY`.

```bash
cd tests
go test -run Test_todoRequest -v    # 100 POST requests to Todo API
go test -run Test_cepRequest -v     # 100 concurrent GET requests to CEP API
go test -run Test_ipRequest -v      # 10,000 concurrent GET requests to IP API (load test)
```

## Key Configuration

- **KIND cluster config**: `k8s/kind-local/clusterconfig.yaml` (ports 80, 443, 49412 mapped to host)
- **Kong Gateway/GatewayClass**: `k8s/kong/gateway.yaml` (uses Kubernetes Gateway API v1)
- **GKE cluster**: `terraform/k8s-cluster.tf` (e2-standard-2 spot instances, auto-scaling 5-10 nodes, us-central1-c)
- **Network**: `terraform/network.tf` (VPC 10.0.0.0/16, NAT gateway, firewall rules)
- All `.env` files are gitignored; use the `.env.example` files as templates
