module "tenant" {
  source             = "github.com/mozilla/terraform-modules//google_tenant_bootstrap?ref=google_tenant_bootstrap-0.1.0"
  application        = "testapp1"
  function           = "webservices"
  risk_level         = "high"
  realm              = "nonprod"
  environment        = "dev"
  github_repository  = "example-org/testapp1"
  wip_project_number = 123456789012
}

module "lightweight_tenant" {
  source                      = "github.com/mozilla/terraform-modules//google_tenant_bootstrap?ref=google_tenant_bootstrap-0.1.0"
  application                 = "testapp2"
  function                    = "aiservices"
  realm                       = "nonprod"
  environment                 = "dev"
  disable_shared_integrations = true
  github_build_repositories   = ["example-org/testapp2"]
  wip_project_number          = 123456789012
}
