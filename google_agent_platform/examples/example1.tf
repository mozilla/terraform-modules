module "agent_platform_nonprod" {
  source              = "github.com/mozilla/terraform-modules//google_agent_platform?ref=google_agent_platform-0.1.0"
  application         = "example-agents"
  environment         = "dev"
  project_id          = "example-agents-nonprod"
  deploy_repositories = ["example-org/example-agents"]
  secret_readers      = ["group:agent-developers@example.com"]
  wip_project_number  = 123456789012
}

module "agent_platform_prod" {
  source                    = "github.com/mozilla/terraform-modules//google_agent_platform?ref=google_agent_platform-0.1.0"
  application               = "example-agents"
  environment               = "prod"
  project_id                = "example-agents-prod"
  deploy_repositories       = ["example-org/example-agents"]
  deploy_github_environment = "prod"
  gcp_organization_id       = 123456789012
  wip_project_number        = 123456789012
  image_repository = {
    project  = "example-agents-prod"
    location = "us"
    name     = "example-agents-prod"
  }
}
