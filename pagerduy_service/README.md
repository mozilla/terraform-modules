## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_pagerduty"></a> [pagerduty](#requirement\_pagerduty) | ~> 3.30.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_pagerduty"></a> [pagerduty](#provider\_pagerduty) | ~> 3.30.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [pagerduty_service.service](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service) | resource |
| [pagerduty_service_integration.cloudwatch](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.email](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.events_api_v2](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.grafana](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.nagios](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.newrelic](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.pingdom](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.stackdriver](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_vendor.cloudwatch](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/data-sources/vendor) | data source |
| [pagerduty_vendor.nagios](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/data-sources/vendor) | data source |
| [pagerduty_vendor.newrelic](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/data-sources/vendor) | data source |
| [pagerduty_vendor.pingdom](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/data-sources/vendor) | data source |
| [pagerduty_vendor.stackdriver](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/data-sources/vendor) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acknowledgement_timeout"></a> [acknowledgement\_timeout](#input\_acknowledgement\_timeout) | Seconds before un-acked incidents re-trigger. 0 disables. | `number` | `0` | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application | `string` | n/a | yes |
| <a name="input_auto_resolve_timeout"></a> [auto\_resolve\_timeout](#input\_auto\_resolve\_timeout) | Seconds before incidents auto-resolve. 0 disables. | `number` | `0` | no |
| <a name="input_description"></a> [description](#input\_description) | PagerDuty service description. | `string` | `""` | no |
| <a name="input_escalation_policy_ids"></a> [escalation\_policy\_ids](#input\_escalation\_policy\_ids) | Map of escalation policy names to IDs (from pagerduty\_team module). | `map(string)` | n/a | yes |
| <a name="input_escalation_policy_name"></a> [escalation\_policy\_name](#input\_escalation\_policy\_name) | Name of the escalation policy to attach to this service. | `string` | n/a | yes |
| <a name="input_integrations"></a> [integrations](#input\_integrations) | Which integrations to create/enabled for this service. | <pre>object({<br/>    events_api_v2 = optional(bool, false)<br/>    pingdom       = optional(bool, false)<br/>    email         = optional(bool, false)<br/>    cloudwatch    = optional(bool, false)<br/>    grafana       = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | PagerDuty service name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | n/a |
