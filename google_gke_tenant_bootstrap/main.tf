module "google_gsm_for_gke" {
  source = "github.com/mozilla/terraform-modules//google_gsm_for_gke?ref=main"

  project_id         = var.project_id
  environment        = var.environment
  cluster_project_id = var.gke_cluster_project_id
  namespace          = var.application
}

module "google_deployment_accounts" {
  source = "github.com/mozilla/terraform-modules//google_deployment_accounts?ref=main"

  project_id         = var.project_id
  environment        = var.environment
  github_repository  = var.github_repository
  wip_name           = var.wip_name
  wip_project_number = var.wip_project_number
}

module "google_gar" {
  source = "github.com/mozilla/terraform-modules//google_gar?ref=main"

  project            = var.project_id
  application        = var.application
  realm              = var.realm      
}
