# A more complex example using attribute specifiers directly. Allow OIDC access
# from CircleCI jobs triggered on the main branch of org/repo1 and org/repo2,
# as well as any job using the fake-context context
data "terraform_remote_state" "wip_project" {
  backend = "gcs"

  config = {
    bucket = "my-wip-project"
    prefix = "wip-project/prefix"
  }
}

locals {
  allowed_repos = formatlist("attribute.vcs/github.com/org/%s:refs/heads/main", ["repo1", "repo2"])
  allowed_contexts = formatlist("attribute.context_id/%s",
    one(values({ "fake-context" = "6e1515f7-40f0-4063-a74a-d77d22ee9f7e" }
  )))
}

module "google_deployment_accounts" {
  source             = "github.com/mozilla/terraform-modules//google_deployment_accounts?ref=main"
  project            = "my-project"
  environment        = "prod"
  wip_name           = "circleci"
  wip_project_number = data.terraform_remote_state.wip_project.number
  circleci_attribute_specifiers = setunion(
    local.allowed_repos,
    local.allowed_contexts,
  )
}
