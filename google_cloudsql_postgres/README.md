# gcp-postgres
Creates a PostgreSQL instance within GCP using Cloud SQL

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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application e.g., bouncer. | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `any` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `any` | n/a | yes |
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | n/a | `list` | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | high availability (REGIONAL) or single zone (ZONAL) | `string` | `"REGIONAL"` | no |
| <a name="input_component"></a> [component](#input\_component) | A logical component of an application | `string` | `"db"` | no |
| <a name="input_connector_enforcement"></a> [connector\_enforcement](#input\_connector\_enforcement) | Enables the enforcement of Cloud SQL Auth Proxy or Cloud SQL connectors for all the connections. If enabled, all the direct connections are rejected. | `string` | `null` | no |
| <a name="input_custom_database_name"></a> [custom\_database\_name](#input\_custom\_database\_name) | Use this field for custom database name. | `string` | `""` | no |
| <a name="input_custom_replica_name"></a> [custom\_replica\_name](#input\_custom\_replica\_name) | Custom database replica name. | `string` | `""` | no |
| <a name="input_data_cache_enabled"></a> [data\_cache\_enabled](#input\_data\_cache\_enabled) | Whether data cache is enabled for the instance. Only available for `ENTERPRISE_PLUS` edition instances. | `bool` | `true` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | A list of database flag maps: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html | `list` | `[]` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | n/a | `string` | `"POSTGRES_13"` | no |
| <a name="input_db_cpu"></a> [db\_cpu](#input\_db\_cpu) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"2"` | no |
| <a name="input_db_mem_gb"></a> [db\_mem\_gb](#input\_db\_mem\_gb) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"12"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether the instance is protected from deletion (TF) | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Whether the instance is protected from deletion (API) | `bool` | `true` | no |
| <a name="input_edition"></a> [edition](#input\_edition) | The edition of the instance, can be `ENTERPRISE` or `ENTERPRISE_PLUS`. | `string` | `"ENTERPRISE"` | no |
| <a name="input_enable_insights_config_on_replica"></a> [enable\_insights\_config\_on\_replica](#input\_enable\_insights\_config\_on\_replica) | If true, will allow enable insights config on replica | `bool` | `false` | no |
| <a name="input_enable_private_path_for_google_cloud_services"></a> [enable\_private\_path\_for\_google\_cloud\_services](#input\_enable\_private\_path\_for\_google\_cloud\_services) | If true, will allow Google Cloud Services access over private IP. | `bool` | `false` | no |
| <a name="input_enable_public_ip"></a> [enable\_public\_ip](#input\_enable\_public\_ip) | If true, will assign a public IP to database instance. | `bool` | `false` | no |
| <a name="input_instance_version"></a> [instance\_version](#input\_instance\_version) | Version of database. Use this field if you need to spin up a new database instance. | `string` | `"v1"` | no |
| <a name="input_ip_configuration_ssl_mode"></a> [ip\_configuration\_ssl\_mode](#input\_ip\_configuration\_ssl\_mode) | n/a | `string` | `"ALLOW_UNENCRYPTED_AND_ENCRYPTED"` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | n/a | `number` | `1` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | n/a | `number` | `17` | no |
| <a name="input_maintenance_window_update_track"></a> [maintenance\_window\_update\_track](#input\_maintenance\_window\_update\_track) | n/a | `string` | `"stable"` | no |
| <a name="input_network"></a> [network](#input\_network) | Network where the private peering should attach. | `string` | `"default"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where database should be provisioned. | `string` | `"us-west1"` | no |
| <a name="input_replica_availability_type"></a> [replica\_availability\_type](#input\_replica\_availability\_type) | Allow setting availability configuration of replica | `string` | `"ZONAL"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | n/a | `number` | `0` | no |
| <a name="input_replica_db_cpu"></a> [replica\_db\_cpu](#input\_replica\_db\_cpu) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"2"` | no |
| <a name="input_replica_db_mem_gb"></a> [replica\_db\_mem\_gb](#input\_replica\_db\_mem\_gb) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"12"` | no |
| <a name="input_replica_region_override"></a> [replica\_region\_override](#input\_replica\_region\_override) | This OVERRIDES var.region for replicas (replicas use var.region per default). | `any` | `null` | no |
| <a name="input_replica_tier_override"></a> [replica\_tier\_override](#input\_replica\_tier\_override) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.replica\_db\_cpu and var.replica\_db\_mem\_gb | `any` | `null` | no |
| <a name="input_tier_override"></a> [tier\_override](#input\_tier\_override) | See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.db\_cpu and var.db\_mem\_gb | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | n/a |
| <a name="output_database_instance"></a> [database\_instance](#output\_database\_instance) | n/a |
| <a name="output_db_instance_ip"></a> [db\_instance\_ip](#output\_db\_instance\_ip) | n/a |
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | n/a |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | n/a |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | n/a |
| <a name="output_replica_connection_names"></a> [replica\_connection\_names](#output\_replica\_connection\_names) | n/a |
| <a name="output_replica_instance"></a> [replica\_instance](#output\_replica\_instance) | n/a |
| <a name="output_replica_private_ip_address"></a> [replica\_private\_ip\_address](#output\_replica\_private\_ip\_address) | n/a |
| <a name="output_replica_public_ip_address"></a> [replica\_public\_ip\_address](#output\_replica\_public\_ip\_address) | n/a |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | n/a |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | n/a |
