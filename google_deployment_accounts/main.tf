/**
 * # Terraform Module: Service Accounts for deployment from GitHub Actions
 * Creates a Cloud IAM service accounts which let GitHub Actions workflows authenticate to GKE.
 */

resource "google_service_account" "account" {
  account_id   = coalesce(var.account_id, "deploy-${var.environment}")
  display_name = "Deployment to the ${var.environment} environment"
  project      = var.project
}

resource "google_service_account_iam_binding" "github-actions-access" {
  service_account_id = google_service_account.account.name
  role               = "roles/iam.workloadIdentityUser"
  members            = local.github_deploy_members
}
