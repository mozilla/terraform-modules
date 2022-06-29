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

  database_version = "MYSQL_8_0"

  maintenance_window_update_track = local.realm == "prod" ? "stable" : "canary"

}

output "mysql_database" {
  sensitive = true
  value     = module.mysql_database
}
