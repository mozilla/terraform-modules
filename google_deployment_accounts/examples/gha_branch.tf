module "google_deployment_accounts_branch" {
  source             = "github.com/mozilla/terraform-modules//google_deployment_accounts?ref=main"
  project            = "my-project"
  environment        = "prod"
  github_repository  = "mozilla/my-repo"
  wip_name           = "github-actions"
  wip_project_number = 12345
  gha_branches       = ["main"]
}
