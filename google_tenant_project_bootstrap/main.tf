module "google_gke_tenant" {
  source = "github.com/mozilla/terraform-modules//google_gke_tenant?ref=main"

  project_id         = var.project
  environment        = var.environment
  cluster_project_id = var.gke_cluster_project_id
  application        = var.application
}

module "google_deployment_accounts" {
  source = "github.com/mozilla/terraform-modules//google_deployment_accounts?ref=main"

  project            = var.project
  environment        = var.environment
  github_repository  = var.github_repository
  wip_name           = var.wip_name
  wip_project_number = var.wip_project_number
}

module "google_gar" {
  source = "github.com/mozilla/terraform-modules//google_gar?ref=main"

  project     = var.project
  application = var.application
  realm       = var.realm
}
