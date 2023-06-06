# Terraform Module: Redis
Creates a Redis instance within GCP using Cloud Memorystore

## Example

```hcl
locals {
  name     = "test-redis"
  realm    = "nonprod"
  networks = try(data.terraform_remote_state.vpc.outputs.networks.realm[local.realm], {})
}

module "redis" {
  source = "github.com/mozilla/terraform-modules//google_redis?ref=main"

  application    = local.name
  environment    = "dev"
  realm          = local.realm
  memory_size_gb = 2
  redis_configs = {
    maxmemory-policy = "allkeys-lru"
  }
  tier               = "STANDARD_HA"
  authorized_network = local.networks.id
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application e.g., bouncer. | `string` | n/a | yes |
| <a name="input_authorized_network"></a> [authorized\_network](#input\_authorized\_network) | The network name of the shared VPC | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `string` | n/a | yes |
| <a name="input_redis_configs"></a> [redis\_configs](#input\_redis\_configs) | Redis configs https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Instance.FIELDS.redis_configs | `map(string)` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Service tier of the instance. Either BASIC or STANDARD\_HA | `string` | n/a | yes |
| <a name="input_auth_enabled"></a> [auth\_enabled](#input\_auth\_enabled) | Controls whether auth is enabled | `bool` | `false` | no |
| <a name="input_component"></a> [component](#input\_component) | A logical component of an application | `string` | `"cache"` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Use this field to set a custom name for the redis instance | `string` | `""` | no |
| <a name="input_enable_persistence"></a> [enable\_persistence](#input\_enable\_persistence) | Controls whether peristence features are enabled | `bool` | `false` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | Day of the week maintenance should occur | `string` | `"TUESDAY"` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | The hour (from 0-23) when maintenance should start | `number` | `16` | no |
| <a name="input_memory_size_gb"></a> [memory\_size\_gb](#input\_memory\_size\_gb) | Memory size in GiB | `number` | `1` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | `null` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | n/a | `string` | `"REDIS_6_X"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `null` | no |
| <a name="input_transit_encryption_mode"></a> [transit\_encryption\_mode](#input\_transit\_encryption\_mode) | Controls whether tls is enabled | `string` | `"DISABLED"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_current_location_id"></a> [current\_location\_id](#output\_current\_location\_id) | n/a |
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_persistence_iam_identity"></a> [persistence\_iam\_identity](#output\_persistence\_iam\_identity) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
