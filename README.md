# Theory
1. How Kong works with K8s

# Crate
1. Create a local kind Cluster.
2. Crete K8s cluster using terraform in google cloud.

gcloud container clusters get-credentials kcd-cluster-a  \
  --zone us-central1-c \
  --project kdc-lima

3. Run this:
```
kubectl apply -f https://raw.githubusercontent.com/percona/percona-server-mysql-operator/v1.0.0/deploy/bundle.yaml
```

```
kubectl apply -f https://raw.githubusercontent.com/percona/percona-server-mysql-operator/v1.0.0/deploy/cr.yaml
```
