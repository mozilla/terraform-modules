# cloudsql-mysql
Creates CloudSQL MySQL Instance.

## MVP Example

```hcl
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

```

## Example with more

```hcl
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

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application e.g., bouncer. | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `any` | n/a | yes |
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | A list of authorized\_network maps: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html | `list` | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#availability_type | `string` | `"ZONAL"` | no |
| <a name="input_component"></a> [component](#input\_component) | A logical component of an application | `string` | `"db"` | no |
| <a name="input_custom_database_name"></a> [custom\_database\_name](#input\_custom\_database\_name) | Use this field for custom database name. | `string` | `""` | no |
| <a name="input_custom_replica_name"></a> [custom\_replica\_name](#input\_custom\_replica\_name) | Custom database replica name. | `string` | `""` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The database flags for the primary instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags#list-flags-mysql) | `list(object({ name = string, value = string }))` | `[]` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | Version of MySQL to run | `string` | `"MYSQL_8_0"` | no |
| <a name="input_db_cpu"></a> [db\_cpu](#input\_db\_cpu) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"2"` | no |
| <a name="input_db_mem_gb"></a> [db\_mem\_gb](#input\_db\_mem\_gb) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"12"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether the instance is protected from deletion | `bool` | `true` | no |
| <a name="input_enable_public_ip"></a> [enable\_public\_ip](#input\_enable\_public\_ip) | If true, will assign a public IP to database instance. | `bool` | `false` | no |
| <a name="input_force_ha"></a> [force\_ha](#input\_force\_ha) | If set to true, create a mysql replica for HA. Currently the availability\_type works only for postgres | `bool` | `false` | no |
| <a name="input_instance_version"></a> [instance\_version](#input\_instance\_version) | Version of database. Use this field if you need to spin up a new database instance. | `string` | `"v1"` | no |
| <a name="input_ip_configuration_require_ssl"></a> [ip\_configuration\_require\_ssl](#input\_ip\_configuration\_require\_ssl) | n/a | `bool` | `true` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | n/a | `number` | `2` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | n/a | `number` | `16` | no |
| <a name="input_maintenance_window_update_track"></a> [maintenance\_window\_update\_track](#input\_maintenance\_window\_update\_track) | n/a | `string` | `"stable"` | no |
| <a name="input_network"></a> [network](#input\_network) | Network where the private peering should attach. | `string` | `"default"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | `null` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-west1"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | Number of replicas to create | `number` | `0` | no |
| <a name="input_tier_override"></a> [tier\_override](#input\_tier\_override) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.db\_cpu and var.db\_mem\_gb | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | n/a |
| <a name="output_database_instance"></a> [database\_instance](#output\_database\_instance) | n/a |
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | n/a |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | n/a |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | n/a |
| <a name="output_replica_instance"></a> [replica\_instance](#output\_replica\_instance) | n/a |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | n/a |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | n/a |
