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
  display_name = coalesce(var.display_name, "Deployment to the ${var.environment} environment")
  project      = var.project
}

resource "google_service_account_iam_binding" "github-actions-access" {
  count              = local.gha_count
  service_account_id = google_service_account.account.name
  role               = "roles/iam.workloadIdentityUser"
  members            = local.github_deploy_members
}

locals {
  circleci = var.wip_name == "circleci"
  # explicit attributes replace all other kinds of assertions
  circleci_attribute_assertions = local.circleci ? [for attribute_specifier in var.circleci_attribute_specifiers :
    "principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/${attribute_specifier}"
  ] : []
  # single repo, all branches
  circleci_vcs_origin_assertions = local.circleci && var.github_repository != null && length(var.circleci_branches) == 0 ? ["principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/attribute.vcs_origin/github.com/${var.github_repository}",
  ] : []
  # single repo, specific branches
  circleci_vcs_assertions = var.wip_name == "circleci" && var.github_repository != null && length(var.circleci_branches) > 0 ? [
    for branch in var.circleci_branches :
    "principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/attribute.vcs/github.com/${var.github_repository}:refs/heads/${branch}"
  ] : []
  # specific CircleCI Context
  circleci_context_id_assertions = local.circleci && length(var.circleci_context_ids) > 0 ? [
    for context in var.circleci_context_ids :
    "principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/attribute.context_id/${context}"
  ] : []
}

resource "google_service_account_iam_binding" "circleci-access" {
  count              = local.circleci_count
  service_account_id = google_service_account.account.name
  role               = "roles/iam.workloadIdentityUser"
  # test value generated via GUI, assertions should look something like:
  # "principalSet://iam.googleapis.com/projects/12141114016/locations/global/workloadIdentityPools/circleci-2/attribute.aud/c3874144-7d38-44e8-8b38-f6b8778a4eb0"
  members = length(local.circleci_attribute_assertions) > 0 ? local.circleci_attribute_assertions : setunion(
    local.circleci_attribute_assertions,
    local.circleci_vcs_origin_assertions,
    local.circleci_vcs_assertions,
    local.circleci_context_id_assertions,
  )
}
