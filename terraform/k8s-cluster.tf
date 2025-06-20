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
    min_node_count = 3
    max_node_count = 7
  }

  node_config {
    spot         = true
    machine_type = "e2-standard-2"
    disk_size_gb = 15
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