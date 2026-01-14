locals {
  integrations = {
    events_api_v2 = try(var.integrations.events_api_v2, false)
    pingdom       = try(var.integrations.pingdom, false)
    email         = try(var.integrations.email, false)
    cloudwatch    = try(var.integrations.cloudwatch, false)
    grafana       = try(var.integrations.grafana, false)
  }


  escalation_policy_id = lookup(
    var.escalation_policy_ids,
    var.escalation_policy_name,
    null
  )
}

