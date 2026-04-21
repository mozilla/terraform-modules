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
| [pagerduty_escalation_policy.escalation_policy](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/escalation_policy) | resource |
| [pagerduty_schedule.schedule](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/schedule) | resource |
| [pagerduty_team.team](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/team) | resource |
| [pagerduty_team_membership.this](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/team_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_escalation_policies"></a> [escalation\_policies](#input\_escalation\_policies) | Escalation policies to create for this team. | <pre>list(object({<br/>    name                             = string<br/>    description                      = optional(string, "")<br/>    num_loops                        = number<br/>    rule_escalation_delay_in_minutes = number<br/>    escalation_rule_schedules        = list(string) # schedule names from var.schedules[*].name<br/>  }))</pre> | `[]` | no |
| <a name="input_manager_members"></a> [manager\_members](#input\_manager\_members) | PagerDuty user IDs to add as managers/admins. | `list(string)` | `[]` | no |
| <a name="input_observer_members"></a> [observer\_members](#input\_observer\_members) | PagerDuty user IDs to add as observers. | `list(string)` | `[]` | no |
| <a name="input_responder_members"></a> [responder\_members](#input\_responder\_members) | PagerDuty user IDs to add as responders. | `list(string)` | `[]` | no |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | Schedules to create for this team. | <pre>list(object({<br/>    name                         = string<br/>    time_zone                    = optional(string, "UTC")<br/>    start                        = string<br/>    rotation_virtual_start       = string<br/>    rotation_turn_length_seconds = number<br/>    users                        = list(string) # PD user IDs<br/>  }))</pre> | `[]` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | PagerDuty team name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_escalation_policy_ids"></a> [escalation\_policy\_ids](#output\_escalation\_policy\_ids) | n/a |
| <a name="output_schedule_ids"></a> [schedule\_ids](#output\_schedule\_ids) | n/a |
| <a name="output_team_id"></a> [team\_id](#output\_team\_id) | n/a |
