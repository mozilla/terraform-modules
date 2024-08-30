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
| <a name="input_connector_enforcement"></a> [connector\_enforcement](#input\_connector\_enforcement) | Enables the enforcement of Cloud SQL Auth Proxy or Cloud SQL connectors for all the connections. If enabled, all the direct connections are rejected. | `string` | `null` | no |
| <a name="input_custom_database_name"></a> [custom\_database\_name](#input\_custom\_database\_name) | Use this field for custom database name. | `string` | `""` | no |
| <a name="input_custom_replica_name"></a> [custom\_replica\_name](#input\_custom\_replica\_name) | Custom database replica name. | `string` | `""` | no |
| <a name="input_data_cache_enabled"></a> [data\_cache\_enabled](#input\_data\_cache\_enabled) | Whether data cache is enabled for the instance. Only available for `ENTERPRISE_PLUS` edition instances. | `bool` | `true` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The database flags for the primary instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags#list-flags-mysql) | `list(object({ name = string, value = string }))` | `[]` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | Version of MySQL to run | `string` | `"MYSQL_8_0"` | no |
| <a name="input_db_cpu"></a> [db\_cpu](#input\_db\_cpu) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"2"` | no |
| <a name="input_db_mem_gb"></a> [db\_mem\_gb](#input\_db\_mem\_gb) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"12"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether the instance is protected from deletion (TF) | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Whether the instance is protected from deletion (API) | `bool` | `true` | no |
| <a name="input_edition"></a> [edition](#input\_edition) | The edition of the instance, can be `ENTERPRISE` or `ENTERPRISE_PLUS`. | `string` | `"ENTERPRISE"` | no |
| <a name="input_enable_private_path_for_google_cloud_services"></a> [enable\_private\_path\_for\_google\_cloud\_services](#input\_enable\_private\_path\_for\_google\_cloud\_services) | If true, will allow Google Cloud Services access over private IP. | `bool` | `false` | no |
| <a name="input_enable_public_ip"></a> [enable\_public\_ip](#input\_enable\_public\_ip) | If true, will assign a public IP to database instance. | `bool` | `false` | no |
| <a name="input_force_ha"></a> [force\_ha](#input\_force\_ha) | If set to true, create a mysql replica for HA. Currently the availability\_type works only for postgres | `bool` | `false` | no |
| <a name="input_instance_version"></a> [instance\_version](#input\_instance\_version) | Version of database. Use this field if you need to spin up a new database instance. | `string` | `"v1"` | no |
| <a name="input_ip_configuration_ssl_mode"></a> [ip\_configuration\_ssl\_mode](#input\_ip\_configuration\_ssl\_mode) | n/a | `string` | `"ALLOW_UNENCRYPTED_AND_ENCRYPTED"` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | Maintenance window day | `number` | `2` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | Maintenance window hour | `number` | `16` | no |
| <a name="input_maintenance_window_update_track"></a> [maintenance\_window\_update\_track](#input\_maintenance\_window\_update\_track) | Receive updates earlier (canary) or later (stable) | `string` | `"stable"` | no |
| <a name="input_network"></a> [network](#input\_network) | Network where the private peering should attach. | `string` | `"default"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID | `string` | `null` | no |
| <a name="input_query_insights_enabled"></a> [query\_insights\_enabled](#input\_query\_insights\_enabled) | Enable / disable Query Insights (See: https://cloud.google.com/sql/docs/mysql/using-query-insights) | `bool` | `true` | no |
| <a name="input_query_plans_per_minute"></a> [query\_plans\_per\_minute](#input\_query\_plans\_per\_minute) | Query Insights: sampling rate | `number` | `5` | no |
| <a name="input_query_string_length"></a> [query\_string\_length](#input\_query\_string\_length) | Query Insights: length of queries | `number` | `1024` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `string` | `""` | no |
| <a name="input_record_application_tags"></a> [record\_application\_tags](#input\_record\_application\_tags) | Query Insights: storage application tags | `bool` | `false` | no |
| <a name="input_record_client_address"></a> [record\_client\_address](#input\_record\_client\_address) | Query Insights: store client IP address | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region to use for Google SQL instance | `string` | `"us-west1"` | no |
| <a name="input_replica_availability_type_override"></a> [replica\_availability\_type\_override](#input\_replica\_availability\_type\_override) | This OVERRIDES var.availability\_type for replicas (replicas use var.availability\_type per default).) | `string` | `""` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | Number of replicas to create | `number` | `0` | no |
| <a name="input_replica_db_cpu"></a> [replica\_db\_cpu](#input\_replica\_db\_cpu) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"2"` | no |
| <a name="input_replica_db_mem_gb"></a> [replica\_db\_mem\_gb](#input\_replica\_db\_mem\_gb) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"12"` | no |
| <a name="input_replica_enable_private_path_for_google_cloud_services"></a> [replica\_enable\_private\_path\_for\_google\_cloud\_services](#input\_replica\_enable\_private\_path\_for\_google\_cloud\_services) | This OVERRIDES var.enable\_private\_path\_for\_google\_cloud\_services for replicas (replicas use var.enable\_private\_path\_for\_google\_cloud\_services per default). | `bool` | `null` | no |
| <a name="input_replica_region_override"></a> [replica\_region\_override](#input\_replica\_region\_override) | This OVERRIDES var.region for replicas (replicas use var.region per default). | `string` | `""` | no |
| <a name="input_replica_tier_override"></a> [replica\_tier\_override](#input\_replica\_tier\_override) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.replica\_db\_cpu and var.replica\_db\_mem\_gb | `string` | `""` | no |
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
| <a name="output_replica_private_ip_address"></a> [replica\_private\_ip\_address](#output\_replica\_private\_ip\_address) | n/a |
| <a name="output_replica_public_ip_address"></a> [replica\_public\_ip\_address](#output\_replica\_public\_ip\_address) | n/a |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | n/a |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | n/a |
