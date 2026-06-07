resource "google_container_cluster" "kcd_cluster_a" {
  name                     = "kcd-cluster-a"
  location                 = "us-central1-c"
  network                  = google_compute_network.kcd_main_network.id
  subnetwork               = google_compute_subnetwork.kcd_subnet_a.id
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "kcd-node-pool"
  cluster    = google_container_cluster.kcd_cluster_a.id
  node_count = 3

  autoscaling {
    min_node_count = 5
    max_node_count = 10
  }

  node_config {
    spot         = true
    machine_type = "e2-standard-2"
    disk_size_gb = 60
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host  = "https://${google_container_cluster.kcd_cluster_a.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.kcd_cluster_a.master_auth[0].cluster_ca_certificate
  )
}

resource "kubernetes_cluster_role_binding" "kcd_cluster_admin" {
  metadata {
    name = "kcd-cluster-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = "kenesparta@pm.me"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [google_container_node_pool.primary_nodes]
}
