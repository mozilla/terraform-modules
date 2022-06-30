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

module "postgres_database" {
  source      = "github.com/mozilla/terraform-modules//google_cloudsql_postgres?ref=main"
  application = "testing-postgres"
  environment = local.environment
  realm       = local.realm
  project_id  = local.project_id

  network = local.subnetworks.regions[local.region].network

  database_version = "POSTGRES_13"

  availability_type = local.realm == "prod" ? "REGIONAL" : "ZONAL"

  db_cpu    = 4
  db_mem_gb = 20
}

output "postgres_database" {
  sensitive = true
  value     = module.postgres_database
}
