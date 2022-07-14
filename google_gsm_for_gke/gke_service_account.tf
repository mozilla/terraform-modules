resource "google_service_account" "gke-account" {
  account_id  = "gke-${var.environment}"
  description = "GKE deployments in the ${var.environment} environment"
  project     = var.project
}

resource "google_service_account_iam_binding" "workload-identity-for-gke" {
  project            = var.project
  service_account_id = google_service_account.gke-account.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.cluster_project_id}.svc.id.goog[${var.namespace}/external-secrets]"
  ]
}

# permissions for use with External Secrets Operator in GKE
#
resource "google_project_iam_member" "sa-role-token-creator" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.gke-account.name}"
}

resource "google_project_iam_member" "sa-role-secret-viewer" {
  project = var.project
  role    = "roles/secretmanager.viewer"
  member  = "serviceAccount:${google_service_account.gke-account.name}"
}

resource "google_project_iam_member" "sa-role-secret-accessor" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.gke-account.name}"
}
