## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.0, < 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.0, < 5 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_logging_project_sink.data_platform_sink](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |
| [google_pubsub_topic_iam_member.data_platform_sink](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [terraform_remote_state.shared_project](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.shared_resources](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Application environment | `string` | n/a | yes |
| <a name="input_log_filter"></a> [log\_filter](#input\_log\_filter) | Log filter string, because presumably you don't want everything? Maybe you do? Example: 'resource.type="http\_load\_balancer" resource.labels.target\_proxy\_name="productdelivery-prod-cdn"' | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project ID | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `string` | n/a | yes |

## Outputs

No outputs.
