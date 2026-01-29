locals {
  created_schedule_ids_by_name = {
    for name, s in pagerduty_schedule.schedule : name => s.id
  }
}


resource "pagerduty_escalation_policy" "escalation_policy" {
  for_each = local.escalation_policies_by_name

  name        = each.key
  description = try(each.value.description, "")
  num_loops   = each.value.num_loops
  teams       = [pagerduty_team.team.id]

  dynamic "rule" {
    for_each = [
      for schedule_name in each.value.escalation_rule_schedules : schedule_name
      if contains(keys(local.created_schedule_ids_by_name), schedule_name)
    ]

    content {
      escalation_delay_in_minutes = each.value.rule_escalation_delay_in_minutes

      target {
        type = "schedule_reference"
        id   = local.created_schedule_ids_by_name[rule.value]
      }
    }
  }

  depends_on = [
    pagerduty_team.team,
    pagerduty_schedule.schedule
  ]
}
