mock_provider "anthropic" {}

variables {
  application = "app"
}

run "creates_account_rule_and_link_per_workload" {
  command = plan

  variables {
    workloads = {
      "app-dev-api" = {
        issuer_id    = "fdis_example"
        workspace_id = "wrkspc_example"
        claims       = { sub = "spiffe://example/api" }
      }
    }
  }

  assert {
    condition     = anthropic_service_account.workloads["app-dev-api"].organization_role == "developer"
    error_message = "Service accounts must have the developer organization role."
  }

  assert {
    condition     = anthropic_federation_rule.workloads["app-dev-api"].oauth_scope == "workspace:inference"
    error_message = "Rules must grant workspace:inference only."
  }

  assert {
    condition     = anthropic_federation_rule.workloads["app-dev-api"].match.audience == "https://api.anthropic.com"
    error_message = "Rules must match the default audience."
  }

  assert {
    condition     = anthropic_federation_rule.workloads["app-dev-api"].match.claims == tomap({ sub = "spiffe://example/api" })
    error_message = "Rules must match the given claims exactly."
  }

  assert {
    condition     = anthropic_service_account_workspace.workloads["app-dev-api"].workspace_id == "wrkspc_example"
    error_message = "Service account must be a member of the workload's workspace."
  }
}

run "name_must_start_with_application" {
  command = plan

  variables {
    workloads = {
      "other-dev-api" = {
        issuer_id    = "fdis_example"
        workspace_id = "wrkspc_example"
        claims       = { sub = "x" }
      }
    }
  }

  expect_failures = [var.workloads]
}

run "name_must_be_lowercase" {
  command = plan

  variables {
    workloads = {
      "app-Dev-api" = {
        issuer_id    = "fdis_example"
        workspace_id = "wrkspc_example"
        claims       = { sub = "x" }
      }
    }
  }

  expect_failures = [var.workloads]
}

run "claims_are_required" {
  command = plan

  variables {
    workloads = {
      "app-dev-api" = {
        issuer_id    = "fdis_example"
        workspace_id = "wrkspc_example"
        claims       = {}
      }
    }
  }

  expect_failures = [var.workloads]
}
