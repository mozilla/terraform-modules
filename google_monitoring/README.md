## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.32.0 |

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
| <a name="input_uptime_checks"></a> [uptime\_checks](#input\_uptime\_checks) | n/a | <pre>list(object({<br>    name                = string<br>    host                = string<br>    path                = string<br>    request_method      = optional(string, "GET")<br>    content_type        = optional(string)<br>    custom_content_type = optional(string)<br>    body                = optional(string)<br>    timeout             = optional(string, "60s")<br>    period              = optional(string, "300s")<br>    user_labels         = optional(map(string), {})<br>    selected_regions    = optional(list(string), [])<br><br>    accepted_response_status_codes = optional(list(object({<br>      status_value = number<br>    })), [])<br><br>    accepted_response_status_classes = optional(list(object({<br>      status_class = string<br>    })), [])<br><br>    content_matchers = optional(list(object({<br>      content = optional(string)<br>      matcher = optional(string)<br>    })), [])<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.
