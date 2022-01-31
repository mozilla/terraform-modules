# gcp-postgres
Creates a PostgreSQL instance within GCP using Cloud SQL

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.58 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 3.58 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 3.58 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | ~> 3.58 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_sql_database_instance.master](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_sql_database_instance) | resource |
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application e.g., bouncer. | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `any` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `any` | n/a | yes |
| <a name="input_tier_override"></a> [tier\_override](#input\_tier\_override) | database instance tier. overrides `db_cpu` and `db_mem_gb` | `any` | n/a | no |
| <a name="input_db_cpu"></a> [db_cpu](#input\_db\_cpu) | Number of CPUs for the DB instance. Must be even number. See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"2"` | no |
| <a name="input_db_mem_gb"></a> [db_mem_gb](#input\_mem\_gb) | Amount of memory for the DB instance in GB. See: https://cloud.google.com/sql/pricing#2nd-gen-pricing | `string` | `"12"` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | high availability (REGIONAL) or single zone (ZONAL) | `string` | `"REGIONAL"` | no |
| <a name="input_custom_database_name"></a> [custom\_database\_name](#input\_custom\_database\_name) | Use this field for custom database name. | `string` | `""` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | A list of database flag maps: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html | `list` | `[]` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | n/a | `string` | `"POSTGRES_11"` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | database instance disk size in GB, minimum 10 | `string` | `"10"` | no |
| <a name="input_enable_public_ip"></a> [enable\_public\_ip](#input\_enable\_public\_ip) | If true, will assign a public IP to database instance. | `bool` | `false` | no |
| <a name="input_instance_version"></a> [instance\_version](#input\_instance\_version) | Version of database. Use this field if you need to spin up a new database instance. | `string` | `"v1"` | no |
| <a name="input_ip_configuration_authorized_networks"></a> [ip\_configuration\_authorized\_networks](#input\_ip\_configuration\_authorized\_networks) | n/a | `list` | `[]` | no |
| <a name="input_ip_configuration_require_ssl"></a> [ip\_configuration\_require\_ssl](#input\_ip\_configuration\_require\_ssl) | n/a | `bool` | `true` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | n/a | `number` | `1` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | n/a | `number` | `17` | no |
| <a name="input_maintenance_window_update_track"></a> [maintenance\_window\_update\_track](#input\_maintenance\_window\_update\_track) | n/a | `string` | `"stable"` | no |
| <a name="input_network"></a> [network](#input\_network) | Network where the private peering should attach. | `string` | `"default"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where database should be provisioned. | `string` | `"us-west1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_ip"></a> [db\_instance\_ip](#output\_db\_instance\_ip) | n/a |

## Simple Example
```HCL
locals {
  realm       = "nonprod"
  project_id  = "moz-fx-test-modules-nonprod"
  region      = "us-west1"
  environment = "dev"

  subnetworks = try(data.terraform_remote_state.vpc.outputs.subnetworks.realm[local.realm][local.project_id], {})
}

# Configure remote_state for subnet outputs
data "terraform_remote_state" "vpc_host" {
  backend = "gcs"

  config = {
    bucket = "moz-fx-platform-mgmt-global-tf"
    prefix = "projects/vpc"
  }
}

module "postgres_database" {
  source      = "git@github.com:mozilla/terraform-modules.git/google_cloudsql/postgres?ref=main"
  application = "testing-postgres"
  environment = local.environment
  realm       = local.realm
  project_id  = local.project_id

  network = local.subnetworks.regions[local.region].network

  database_version = "POSTGRES_13"

  availability_type = local.realm == "prod" ? "REGIONAL" : "ZONAL"

  db_cpu    = 4
  db_mem_gb = 20
  disk_size = "10"

}


output "postgres_database" {
  sensitive = true
  value     = module.postgres_database
}
```
