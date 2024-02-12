locals {
  github_deploy_repositories = var.github_repository != null ? [var.github_repository] : var.github_repositories

  environments = length(var.gha_environments) > 0 ? var.gha_environments : [var.environment]

  github_deploy_members = flatten([for repo in local.github_deploy_repositories : [for env in local.environments : [
    "principal://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/subject/repo:${repo}:environment:${env}"
  ]]])
}