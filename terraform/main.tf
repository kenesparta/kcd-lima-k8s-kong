terraform {
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5"
    }
  }
}

provider "google" {
  project = var.project_name
}
