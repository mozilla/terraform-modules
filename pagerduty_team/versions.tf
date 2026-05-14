terraform {
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "> 3.29, < 3.31"
    }
  }
}
