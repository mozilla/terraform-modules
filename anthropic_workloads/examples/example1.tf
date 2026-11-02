module "anthropic_workloads" {
  source      = "github.com/mozilla/terraform-modules//anthropic_workloads?ref=anthropic_workloads-0.1.0"
  application = "example"

  workloads = {
    # GitHub Actions job on the main branch.
    "example-prod-api" = {
      issuer_id    = "fdis_example_github"
      workspace_id = "wrkspc_example"
      claims = {
        repository = "example-org/example-repo"
        ref        = "refs/heads/main"
      }
    }

    # Google service account. sub is the service account's numeric unique ID.
    "example-prod-worker" = {
      issuer_id    = "fdis_example_google"
      workspace_id = "wrkspc_example"
      claims = {
        sub   = "111111111111111111111"
        email = "worker@example-project.iam.gserviceaccount.com"
      }
    }

    # Workload with a SPIFFE identity.
    "example-prod-agent" = {
      issuer_id    = "fdis_example_spiffe"
      workspace_id = "wrkspc_example"
      claims = {
        sub = "spiffe://example.org/ns/example/sa/agent"
      }
    }
  }
}

output "workloads" {
  value = module.anthropic_workloads.workloads
}
