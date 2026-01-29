locals {
  schedules_by_name = {
    for s in var.schedules : s.name => s
  }

  escalation_policies_by_name = {
    for ep in var.escalation_policies : ep.name => ep
  }

  # Flatten memberships into one map keyed by "role:user_id"
  memberships = merge(
    { for u in var.observer_members : "group:${u}" => { user_id = u, role = "observer" } },
    { for u in var.responder_members : "group:${u}" => { user_id = u, role = "responder" } },
    { for u in var.manager_members : "group:${u}" => { user_id = u, role = "manager" } },
  )
}
