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
  members = (
    length(var.gha_environments) > 0 ?
    [for env in var.gha_environments : format("%s:%s", "principal://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/subject/repo:${var.github_repository}:environment", env)] :
    ["principal://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/subject/repo:${var.github_repository}:environment:${var.environment}", ]
  )
}
