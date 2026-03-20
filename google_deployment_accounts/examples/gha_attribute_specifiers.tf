# A more complex example using attribute specifiers directly. Allow OIDC access
# from GitHub Actions workflows running on the main branch of org/repo1 and
# org/repo2, as well as any workflow running in the "production" environment.
data "terraform_remote_state" "wip_project" {
  backend = "gcs"

  config = {
    bucket = "my-wip-project"
    prefix = "wip-project/prefix"
  }
}

locals {
  allowed_repo_refs    = formatlist("attribute.repository_ref/org/%s:refs/heads/main", ["repo1", "repo2"])
  allowed_environments = formatlist("attribute.environment/%s", ["production"])
}

module "google_deployment_accounts" {
  source             = "github.com/mozilla/terraform-modules//google_deployment_accounts?ref=main"
  project            = "my-project"
  environment        = "prod"
  wip_name           = "github-actions"
  wip_project_number = data.terraform_remote_state.wip_project.number
  gha_attribute_specifiers = setunion(
    local.allowed_repo_refs,
    local.allowed_environments,
  )
}
