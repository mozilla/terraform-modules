output "team_id" {
  value = pagerduty_team.this.id
}

output "schedule_ids" {
  value = { for k, v in pagerduty_schedule.this : k => v.id }
}

output "escalation_policy_ids" {
  value = { for k, v in pagerduty_escalation_policy.this : k => v.id }
}
