resource "google_dns_managed_zone" "kcd_dns_zone" {
  name     = "kcd-zone"
  dns_name = "${var.domain_name}."
}

resource "google_dns_record_set" "kcd_dns_record" {
  name         = "${var.domain_name}."
  managed_zone = google_dns_managed_zone.kcd_dns_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = ["34.42.115.89"]
}

resource "google_dns_record_set" "www_k8s_dns_record" {
  name         = "www.${var.domain_name}."
  managed_zone = google_dns_managed_zone.kcd_dns_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = ["34.42.115.89"]
}