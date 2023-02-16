# Terraform Module: Memcache
Creates a memcache instance within GCP using Cloud Memorystore

## Example

```hcl
locals {
  name     = "test-memcache"
  realm    = "nonprod"
  networks = try(data.terraform_remote_state.vpc.outputs.networks.realm[local.realm], {})
}

module "memcache" {
  source = "github.com/mozilla/terraform-modules//google_memcache?ref=main"

  application        = local.name
  environment        = "dev"
  realm              = local.realm
  memory_size_mb     = 2048
  authorized_network = local.networks.id
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application e.g., bouncer. | `string` | n/a | yes |
| <a name="input_authorized_network"></a> [authorized\_network](#input\_authorized\_network) | The network name of the shared VPC - expects the format to be: projects/<project-name>/global/networks/<network-name> | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | A logical component of an application | `string` | `"cache"` | no |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | n/a | `number` | `1` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Use this field to set a custom name for the memcache instance | `string` | `""` | no |
| <a name="input_maintenance_duration"></a> [maintenance\_duration](#input\_maintenance\_duration) | The length of the maintenance window in seconds | `string` | `"10800s"` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | Day of the week maintenance should occur | `string` | `"TUESDAY"` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | The hour (from 0-23) when maintenance should start | `number` | `16` | no |
| <a name="input_memcache_configs"></a> [memcache\_configs](#input\_memcache\_configs) | Memcache configs https://cloud.google.com/memorystore/docs/memcached/memcached-configs | `map(string)` | `{}` | no |
| <a name="input_memcache_version"></a> [memcache\_version](#input\_memcache\_version) | n/a | `string` | `"MEMCACHE_1_5"` | no |
| <a name="input_memory_size_mb"></a> [memory\_size\_mb](#input\_memory\_size\_mb) | Memory size in MiB | `number` | `1024` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | n/a | `number` | `1` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_discovery_endpoint"></a> [discovery\_endpoint](#output\_discovery\_endpoint) | n/a |
| <a name="output_memcache_nodes"></a> [memcache\_nodes](#output\_memcache\_nodes) | n/a |
