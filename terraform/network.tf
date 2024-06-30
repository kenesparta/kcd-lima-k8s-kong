resource "google_compute_network" "kcd_main_network" {
  project                 = local.project_name
  name                    = "kcd-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kcd_subnet_a" {
  project       = local.project_name
  name          = "k8s-cluster-subnet-a"
  region        = "us-central1"
  network       = google_compute_network.kcd_main_network.id
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_firewall" "allow_ssh" {
  project = local.project_name
  name    = "allow-ssh"
  network = google_compute_network.kcd_main_network.id

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_http" {
  project = local.project_name
  name    = "allow-http"
  network = google_compute_network.kcd_main_network.id

  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}