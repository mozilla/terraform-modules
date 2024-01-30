# Allow OIDC access from CircleCI jobs triggered in a specific repo
data "terraform_remote_state" "wip_project" {
  backend = "gcs"

  config = {
    bucket = "my-wip-project"
    prefix = "wip-project/prefix"
  }
}

module "google_deployment_accounts" {
  source             = "github.com/mozilla/terraform-modules//google_deployment_accounts?ref=main"
  project            = "my-project"
  environment        = "stage"
  github_repository  = "org/project"
  wip_name           = "circleci"
  wip_project_number = data.terraform_remote_state.wip_project.number
}
