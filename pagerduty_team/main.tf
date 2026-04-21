resource "pagerduty_team" "team" {
  name        = var.team_name
  description = "Team managed by Terraform."
}

resource "pagerduty_team_membership" "this" {
  for_each = local.memberships

  team_id = pagerduty_team.team.id
  user_id = each.value.user_id
  role    = each.value.role
}
