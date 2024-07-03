resource "google_compute_network" "kcd_main_network" {
  name                    = "kcd-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kcd_subnet_a" {
  name          = "k8s-cluster-subnet-a"
  region        = "us-central1"
  network       = google_compute_network.kcd_main_network.id
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.kcd_main_network.id

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_application_ports" {
  name    = "allow-application-ports"
  network = google_compute_network.kcd_main_network.id

  allow {
    protocol = "tcp"
    ports = ["30081"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.kcd_main_network.id

  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-egress" {
  name    = "allow-egress"
  network = google_compute_network.kcd_main_network.id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  direction = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  region  = "us-central1"
  network = google_compute_network.kcd_main_network.name
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "nat-gateway"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}