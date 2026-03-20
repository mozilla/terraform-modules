locals {
  github_deploy_repositories = var.github_repository != null ? [var.github_repository] : var.github_repositories

  environments = length(var.gha_environments) > 0 ? var.gha_environments : [var.environment]

  # GHA principal resolution with precedence:
  # 1. gha_attribute_specifiers set → full override
  # 2. gha_branches set → repository_ref-based principals per repo x branch
  # 3. Neither set (default) → environment-based principals (existing behavior)
  gha_attribute_assertions = [for attribute_specifier in var.gha_attribute_specifiers :
    "principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/${attribute_specifier}"
  ]

  gha_branch_assertions = flatten([for repo in local.github_deploy_repositories : [for branch in var.gha_branches :
    "principalSet://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/attribute.repository_ref/${repo}:refs/heads/${branch}"
  ]])

  gha_environment_assertions = flatten([for repo in local.github_deploy_repositories : [for env in local.environments :
    "principal://iam.googleapis.com/projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}/subject/repo:${repo}:environment:${env}"
  ]])

  github_deploy_members = (
    length(local.gha_attribute_assertions) > 0 ? local.gha_attribute_assertions :
    length(local.gha_branch_assertions) > 0 ? local.gha_branch_assertions :
    local.gha_environment_assertions
  )
}
