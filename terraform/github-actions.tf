# Workload Identity Federation para GitHub Actions: el repo de la charla
# (kenesparta/prometheus-4-piezas) despliega en el cluster autenticándose con
# el token OIDC que emite GitHub en cada run — sin service accounts dedicadas
# ni llaves JSON exportadas.

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-oidc"
  display_name                       = "GitHub OIDC"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  # GCP exige una condición cuando el issuer es multi-tenant como GitHub:
  # solo se aceptan tokens de repos de esta cuenta.
  attribute_condition = "assertion.repository_owner == \"kenesparta\""

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# El workflow desplegar-k8s.yml del repo prometheus-4-piezas (y solo ese
# repo) puede hacer kubectl apply contra los clusters del proyecto.
resource "google_project_iam_member" "prometheus_4_piezas_deploy" {
  project = var.project_name
  role    = "roles/container.developer"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/kenesparta/prometheus-4-piezas"
}

output "github_wif_provider" {
  description = "Valor de workload_identity_provider para google-github-actions/auth"
  value       = google_iam_workload_identity_pool_provider.github.name
}
