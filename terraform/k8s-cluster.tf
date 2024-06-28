# resource "google_container_cluster" "kcd-cluster_a" {
#   name       = "kcd-cluster-a"
#   location   = "us-central1-c"
#   network    = google_compute_network.kcd_main_network.id
#   subnetwork = google_compute_subnetwork.kcd_subnet_a.id
#
#   node_pool {
#     name               = "default-node-pool"
#     initial_node_count = 3
#     machine_type       = "n2d-standard-2"
#     disk_size_gb       = 100
#   }
# }
