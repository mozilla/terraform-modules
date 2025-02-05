<!-- BEGIN_TF_DOCS -->


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Application environment | `string` | n/a | yes |
| <a name="input_log_filter"></a> [log\_filter](#input\_log\_filter) | Log filter string, because presumably you don't want everything? Maybe you do? Example: 'resource.type="http\_load\_balancer" resource.labels.target\_proxy\_name="productdelivery-prod-cdn"' | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
