# Terraform Module: Redis
Creates a Redis instance within GCP using Cloud Memorystore

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.11 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_service.redis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_redis_instance.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application e.g., bouncer. | `any` | n/a | yes |
| <a name="input_authorized_network"></a> [authorized\_network](#input\_authorized\_network) | n/a | `string` | `"default"` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Use this field to set a custom name for the redis instance | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `any` | n/a | yes |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | Day of the week maintenance should occur | `string` | `"TUESDAY"` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | The hour (from 0-23) when maintenance should start | `number` | `16` | no |
| <a name="input_memory_size_gb"></a> [memory\_size\_gb](#input\_memory\_size\_gb) | Memory size in GiB | `number` | `1` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `any` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `any` | n/a | yes |
| <a name="input_redis_configs"></a> [redis\_configs](#input\_redis\_configs) | Redis configs https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Instance.FIELDS.redis_configs | `map(any)` | n/a | yes |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | n/a | `string` | `"REDIS_6_X"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-west1"` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | Service tier of the instance. Either BASIC or STANDARD\_HA | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_current_location_id"></a> [current\_location\_id](#output\_current\_location\_id) | n/a |
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_persistence_iam_identity"></a> [persistence\_iam\_identity](#output\_persistence\_iam\_identity) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
