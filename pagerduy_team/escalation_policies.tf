resource "pagerduty_escalation_policy" "escalation_policy" {
  for_each = local.escalation_policies_by_name

  name        = "${each.key}"
  description = try(each.value.description, "")
  num_loops   = each.value.num_loops
  teams       = [pagerduty_team.team.id]

  dynamic "rule" {
    for_each = tolist(each.value.escalation_rule_schedules)

    content {
      escalation_delay_in_minutes = each.value.rule_escalation_delay_in_minutes

      target {
        type = "schedule_reference"
        id   = pagerduty_schedule.escalation_policy[rule.value].id
      }
    }
  }
}
