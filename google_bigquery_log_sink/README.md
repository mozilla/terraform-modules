## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_logging_project_sink.self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |
| [google_project_iam_member.self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Application environment | `string` | n/a | yes |
| <a name="input_log_filter"></a> [log\_filter](#input\_log\_filter) | Log filter string, because presumably you don't want everything? Maybe you do? Example: 'resource.type="http\_load\_balancer" resource.labels.target\_proxy\_name="productdelivery-prod-cdn"' | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project ID | `string` | n/a | yes |

## Outputs

No outputs.
