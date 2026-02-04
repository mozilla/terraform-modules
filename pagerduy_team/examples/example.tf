locals {
  users        = ["engineerA@mozilla.com", "engineerB@mozilla.com"]
  team_manager = ["manager@mozilla.com"]
}

data "pagerduty_user" "team_users" {
  for_each = toset(local.users)
  email    = each.value
}

module "pagerduty_team" {
  source = "github.com/mozilla/terraform-modules//pagerduy_team?ref=main"

  team_name = "foo"

  schedules = [
    {
      name                         = "bar"
      time_zone                    = "America/New_York"
      start                        = "2026-01-12T00:00:00-00:00"
      rotation_virtual_start       = "2026-01-12T00:00:00-00:00"
      rotation_turn_length_seconds = 604800 # 7d
      users                        = local.users
    },
    {
      name                         = "glab"
      time_zone                    = "America/New_York"
      start                        = "2026-01-12T09:00:00-05:00"
      rotation_virtual_start       = "2026-01-12T09:00:00-05:00"
      rotation_turn_length_seconds = 604800 # 7d
      # Reorder the team member list to be used as a secondary escalation layer.
      users = [
        for email in(
          concat(slice(local.users, 1, length(local.users)), [local.users[0]])
        ) : data.pagerduty_user.team_users[email].id
      ]
    },
  ]

  escalation_policies = [
    {
      name                             = "default"
      description                      = "glob"
      num_loops                        = 2 #The number of times the escalation policy will repeat after reaching the end of its escalation.
      rule_escalation_delay_in_minutes = 15
      escalation_rule_schedules        = ["bar", "glab"] #The Schedule names created above to be used on this escalation policy.
    }
  ]
}
