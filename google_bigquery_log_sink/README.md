<!-- BEGIN_TF_DOCS -->


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dataset_id_override"></a> [dataset\_id\_override](#input\_dataset\_id\_override) | Override the default dataset id | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Application environment | `string` | n/a | yes |
| <a name="input_log_filter"></a> [log\_filter](#input\_log\_filter) | Log filter string, because presumably you don't want everything? Maybe you do? Example: 'resource.type="http\_load\_balancer" resource.labels.target\_proxy\_name="productdelivery-prod-cdn"' | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project ID | `string` | n/a | yes |
| <a name="input_sink_name_override"></a> [sink\_name\_override](#input\_sink\_name\_override) | Override the default logging sink name | `string` | `""` | no |
| <a name="input_use_partitioned_tables"></a> [use\_partitioned\_tables](#input\_use\_partitioned\_tables) | Enable/disable bigquery partition tables | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
