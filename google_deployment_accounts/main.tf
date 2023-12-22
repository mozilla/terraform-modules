/**
 * # Terraform Module: Service Accounts for deployment from GitHub Actions and CircleCI
 * Creates a Cloud IAM service account which lets CI workflows authenticate to GCP.
 */

locals {
  gha_count      = var.wip_name == "github-actions" ? 1 : 0
  circleci_count = var.wip_name == "circleci" ? 1 : 0
}

resource "google_service_account" "account" {
  account_id   = coalesce(var.account_id, "deploy-${var.environment}")
  display_name = "Deployment to the ${var.environment} environment"
  project      = var.project
}

resource "google_service_account_iam_binding" "github-actions-access" {
  count              = local.gha_count
  service_account_id = google_service_account.account.name
  role               = "roles/iam.workloadIdentityUser"
  members            = local.github_deploy_members
}

resource "google_service_account_iam_binding" "circleci-access" {
  count              = local.circleci_count
  service_account_id = google_service_account.account.name
  role               = "roles/iam.workloadIdentityUser"
  members = (
    # test value generated via GUI
    # "principalSet://iam.googleapis.com/projects/12141114016/locations/global/workloadIdentityPools/circleci-2/attribute.aud/c3874144-7d38-44e8-8b38-f6b8778a4eb0",
    length(var.circleci_attribute_specifiers) > 0 ?
    [for attribute_specifier in var.circleci_attribute_specifiers :
    "principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/${attribute_specifier}"] :
    ["principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/attribute.vcs_origin/github.com/${var.github_repository}", ]
  )
}
