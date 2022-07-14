resource "google_service_account" "gke-account" {
  for_each     = toset( var.environment )
  account_id   = "gke-${each.key}"
  description  = "GKE deployments in the ${each.key} environment"
  project      = var.project
}

resource "google_service_account_iam_binding" "workload-identity-for-gke" {
  for_each           = toset( var.environment )
  project            = var.project
  service_account_id = google_service_account.gke-account[each.key].name
  role               = "roles/iam.workloadIdentityUser"
  members            = [
    "serviceAccount:${var.cluster_project_id}.svc.id.goog[${var.namespace}/external-secrets]"
  ]
}

# permissions for use with External Secrets Operator in GKE
#
resource "google_project_iam_member" "sa-role-token-creator" {
  for_each = toset( var.environment )
  project  = var.project
  role     = "roles/iam.serviceAccountTokenCreator"
  member   = "serviceAccount:${google_service_account.gke-account[each.key].name}"
}

resource "google_project_iam_member" "sa-role-secret-viewer" {
  for_each = toset( var.environment )
  project  = var.project
  role     = "roles/secretmanager.viewer"
  member   = "serviceAccount:${google_service_account.gke-account[each.key].name}"
}

resource "google_project_iam_member" "sa-role-secret-accessor" {
  for_each = toset( var.environment )
  project  = var.project
  role     = "roles/secretmanager.secretAccessor"
  member   = "serviceAccount:${google_service_account.gke-account[each.key].name}"
}
