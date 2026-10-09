locals {
  tf_admin_abbrev = {
    aiservices   = "aisvc"
    dataservices = "datasvc"
    sandbox      = "sandbox"
    webservices  = "websvc"
  }
  terraform_service_account = "tf-${var.function}@moz-fx-${local.tf_admin_abbrev[var.function]}-terraform-admin.iam.gserviceaccount.com"

  namespace = format("%s-%s", var.application, var.environment)

  cluster                = var.disable_shared_integrations || var.risk_level == null ? null : var.environment == "preview" ? "sandbox-high" : format("%s-%s", var.function, var.risk_level)
  gke_cluster_project_id = var.disable_shared_integrations ? null : data.terraform_remote_state.platform_shared[0].outputs.projects[local.cluster][var.realm].id

  logging_writer_service_account_member = try(data.terraform_remote_state.gke[0].outputs.logging_writer_service_accounts[local.namespace], "")

  internal_ips                = try(data.terraform_remote_state.gke[0].outputs.internal_ips[local.namespace], {})
  public_ips                  = try(data.terraform_remote_state.gke[0].outputs.public_ips[local.namespace], {})
  writer_service_account_name = data.terraform_remote_state.projects.outputs.projects[var.application][var.realm].writer_service_account_name
  wip_id                      = "projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}"

  github_deploy_repositories = length(var.github_deploy_repositories) > 0 ? var.github_deploy_repositories : compact([var.github_repository])

  github_build_repositories = length(var.github_build_repositories) > 0 ? var.github_build_repositories : compact([var.github_repository])
  github_build_principals = [
    for repo in local.github_build_repositories : var.github_require_build_env ?
    "principal://iam.googleapis.com/${local.wip_id}/subject/repo:${repo}:environment:build" :
    "principalSet://iam.googleapis.com/${local.wip_id}/attribute.repository/${repo}"
    if local.writer_service_account_name != null
  ]

  circleci_build_principals = [
    for repo in var.circleci_build_repositories :
    "principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/circleci/attribute.vcs_origin/github.com/${repo}"
    if local.writer_service_account_name != null
  ]
  build_principals = setunion(local.github_build_principals, local.circleci_build_principals)
}
