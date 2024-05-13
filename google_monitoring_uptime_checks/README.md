## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_monitoring_uptime_check_config.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_uptime_check_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_uptime_checks"></a> [uptime\_checks](#input\_uptime\_checks) | n/a | <pre>list(object({<br>    name    = string<br>    host    = string<br>    path    = string<br>    timeout = optional(string, "60s")<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.
