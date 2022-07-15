resource "google_service_account" "gke-account" {
  account_id  = "gke-${var.environment}"
  description = "GKE deployments in the ${var.environment} environment"
  project     = var.project_id
}

resource "google_service_account_iam_binding" "workload-identity-for-gke" {
  service_account_id = google_service_account.gke-account.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.cluster_project_id}.svc.id.goog[${var.application}-${var.environment}/external-secrets]"
  ]
}

# permissions for use with External Secrets Operator in GKE
#
# FIXME: The below permission isn't required if we use the pod-based workload identity
# https://external-secrets.io/v0.5.8/provider-google-secrets-manager/#using-pod-based-workload-identity
# but the instructions there are ... vague and I don't understand them.
#
resource "google_project_iam_member" "sa-role-token-creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.gke-account.name}"
}

# needed for tag- or regex-based loading of secrets, but not for explicit secret names
#resource "google_project_iam_member" "sa-role-secret-viewer" {
#  project = var.project_id
#  role    = "roles/secretmanager.viewer"
#  member  = "serviceAccount:${google_service_account.gke-account.name}"
#}

resource "google_project_iam_member" "sa-role-secret-accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.gke-account.name}"
}
