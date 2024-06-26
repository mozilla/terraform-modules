resource "google_service_account" "gke-account" {
  account_id  = "gke-${var.environment}"
  description = "GKE deployments in the ${var.environment} environment"
  project     = var.project_id
}

module "workload-identity-for-tenant-sa" {
  source = "github.com/mozilla/terraform-modules//google_workload_identity?ref=main"

  name                = "gha-${var.application}"
  namespace           = "${var.application}-${var.environment}"
  project_id          = var.cluster_project_id
  use_existing_k8s_sa = true
  use_existing_gcp_sa = true
  gcp_sa_name         = google_service_account.gke-account.email
}

module "workload-identity-for-generic-tenant-sa" {
  source = "github.com/mozilla/terraform-modules//google_workload_identity?ref=main"

  name                = var.application
  namespace           = "${var.application}-${var.environment}"
  project_id          = var.cluster_project_id
  use_existing_k8s_sa = true
  use_existing_gcp_sa = true
  gcp_sa_name         = google_service_account.gke-account.email
}

module "workload-identity-for-tenant-external-secrets-sa" {
  source = "github.com/mozilla/terraform-modules//google_workload_identity?ref=main"

  name                = "external-secrets"
  namespace           = "${var.application}-${var.environment}"
  project_id          = var.cluster_project_id
  use_existing_k8s_sa = true
  use_existing_gcp_sa = true
  gcp_sa_name         = google_service_account.gke-account.email
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
  member  = "serviceAccount:${google_service_account.gke-account.email}"
}

# needed for tag- or regex-based loading of secrets, but not for explicit secret names
#resource "google_project_iam_member" "sa-role-secret-viewer" {
#  project = var.project_id
#  role    = "roles/secretmanager.viewer"
#  member  = "serviceAccount:${google_service_account.gke-account.email}"
#}

resource "google_project_iam_member" "sa-role-secret-accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.gke-account.email}"
}
