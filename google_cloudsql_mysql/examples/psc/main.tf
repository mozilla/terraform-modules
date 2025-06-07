locals {
  realm       = "nonprod"
  project_id  = "moz-fx-test-modules-nonprod"
  region      = "us-west1"
  environment = "dev"

  subnetworks = try(data.terraform_remote_state.vpc.outputs.subnetworks.realm[local.realm][local.project_id], {})
}

# Configure remote_state for subnet outputs
data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    bucket = "my-vpc-project"
    prefix = "vpc"
  }
}

module "mysql_database" {
  source      = "github.com/mozilla/terraform-modules//google_cloudsql_mysql?ref=main"
  application = "testing-mysql"
  environment = local.environment
  realm       = local.realm

  network = local.subnetworks.regions[local.region].network

  database_version = "MYSQL_8_4"

  maintenance_window_update_track = local.realm == "prod" ? "stable" : "canary"

  # `psc_allowed_consumer_projects`, and `psc_enabled` must be set for Private Services Connect (PSC) to work
  # To have Google create the PSC endpoint automatically, set `psc_auto_connections` and create a Service Connection Policy in the consumer network project
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_service_connection_policy
  # This policy exists if you're using a MozCloud Shared VPC
  psc_allowed_consumer_projects = [local.project_id]
  psc_auto_connections          = [{
    consumer_network            = local.subnetworks.regions[local.region].network
    consumer_service_project_id = local.project_id
  }]
  psc_enabled = true

  # PSC is not compatible with query insights recording the client IP address
  record_client_address = false
}
