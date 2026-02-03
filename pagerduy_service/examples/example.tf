
module "pagerduty_service" {
  source                  = "github.com/mozilla/terraform-modules//pagerduy_service?ref=main"
  name                    = "foo"
  application_name        = "bar"
  description             = "glab"
  auto_resolve_timeout    = 14400 # seconds (4h)
  acknowledgement_timeout = 1800  # seconds (30m)

  escalation_policy_name = "default" #Name of the escalation policy created on the pager duty team module.
  escalation_policy_ids  = module.pagerduty_team.escalation_policy_ids

  integrations = {
    events_api_v2 = true
    pingdom       = false
    email         = false
    cloudwatch    = false
    grafana       = false
  }
}

