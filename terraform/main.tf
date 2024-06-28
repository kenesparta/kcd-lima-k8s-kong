terraform {
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4"
    }
  }
}

provider "google" {
  project = local.project_name
}
