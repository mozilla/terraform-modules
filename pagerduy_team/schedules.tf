resource "pagerduty_schedule" "schedule" {
  for_each = local.schedules_by_name

  name      = "${each.key}"
  time_zone = try(each.value.time_zone, "UTC")

  layer {
    name                         = each.value.name
    start                        = each.value.start
    rotation_virtual_start       = each.value.rotation_virtual_start
    rotation_turn_length_seconds = each.value.rotation_turn_length_seconds
    users                        = each.value.users
  }

  # Optional: tie schedules to the team if your PD setup wants that in naming/ownership conventions.
}
