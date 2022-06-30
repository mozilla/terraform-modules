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

  # REGIONAL automagically creates a failover replica, so there will be 3 replicas in this config;
  # 1 for HA and 2 read replicas
  #
  replica_count     = 2
  availability_type = "REGIONAL"

  database_version = "MYSQL_8_0"

  maintenance_window_update_track = local.realm == "prod" ? "stable" : "canary"

  database_flags = [
    {
      name  = "slow_query_log",
      value = "on"
    },
    {
      name  = "log_output",
      value = "FILE"
    },
    {
      name  = "long_query_time",
      value = "1"
    },
  ]
}

output "mysql_database" {
  sensitive = true
  value     = module.mysql_database
}
