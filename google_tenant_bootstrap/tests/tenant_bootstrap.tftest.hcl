mock_provider "google" {
  mock_resource "google_service_account" {
    defaults = {
      email = "tenant-sa@app-nonprod.iam.gserviceaccount.com"
    }
  }
}
mock_provider "google-beta" {}
mock_provider "kubernetes" {}

override_data {
  target = data.terraform_remote_state.projects
  values = {
    outputs = {
      projects = {
        app = {
          prod    = { writer_service_account_name = "projects/app-prod/serviceAccounts/artifact-writer@app-prod.iam.gserviceaccount.com" }
          nonprod = { writer_service_account_name = null }
        }
      }
    }
  }
}

override_data {
  target = data.terraform_remote_state.platform_shared
  values = {
    outputs = {
      projects = {
        webservices-high = { nonprod = { id = "webservices-high-nonprod" } }
        sandbox-high     = { nonprod = { id = "sandbox-high-nonprod" } }
      }
    }
  }
}

override_data {
  target = data.terraform_remote_state.gke
  values = {
    outputs = {}
  }
}

override_module {
  target = module.gke_logging
  outputs = {
    logging_bucket_id                = "logs"
    logging_bucket_linked_dataset_id = "logs"
    logging_dataset_id               = "logs"
  }
}

variables {
  application        = "app"
  wip_project_number = 123456789012
}

run "lightweight_prod" {
  command = plan

  variables {
    function                    = "aiservices"
    realm                       = "prod"
    environment                 = "prod"
    project_id                  = "app-prod"
    disable_shared_integrations = true
    github_build_repositories   = ["example-org/app"]
  }

  assert {
    condition     = length(module.google_gke_tenant) == 0 && length(module.gke_logging) == 0
    error_message = "Lightweight tenants must not create GKE resources."
  }

  assert {
    condition     = one(google_service_account_iam_binding.artifact_writer_access[0].members) == "principal://iam.googleapis.com/projects/123456789012/locations/global/workloadIdentityPools/github-actions/subject/repo:example-org/app:environment:build"
    error_message = "Artifact writer must be bound to the build environment of the repo."
  }

  assert {
    condition     = output.gke_cluster_project_id == null && output.gke_service_account_email == null
    error_message = "GKE outputs must be null for lightweight tenants."
  }
}

run "lightweight_nonprod_without_writer" {
  command = plan

  variables {
    function                    = "aiservices"
    realm                       = "nonprod"
    environment                 = "dev"
    project_id                  = "app-nonprod"
    disable_shared_integrations = true
    github_build_repositories   = ["example-org/app"]
  }

  assert {
    condition     = length(google_service_account_iam_binding.artifact_writer_access) == 0
    error_message = "No artifact writer binding when the realm has no writer service account."
  }
}

run "standard" {
  command = plan

  variables {
    function    = "webservices"
    risk_level  = "high"
    realm       = "nonprod"
    environment = "dev"
    project_id  = "app-nonprod"
  }

  assert {
    condition     = length(module.google_gke_tenant) == 1 && length(module.gke_logging) == 1
    error_message = "Standard tenants must create GKE resources."
  }

  assert {
    condition     = output.gke_cluster_project_id == "webservices-high-nonprod"
    error_message = "Standard tenants must target <function>-<risk_level>."
  }
}

run "preview_uses_sandbox_cluster" {
  command = plan

  variables {
    function    = "webservices"
    risk_level  = "high"
    realm       = "nonprod"
    environment = "preview"
    project_id  = "app-nonprod"
  }

  assert {
    condition     = output.gke_cluster_project_id == "sandbox-high-nonprod"
    error_message = "Preview environments must target sandbox-high."
  }
}

run "standard_requires_risk_level" {
  command = plan

  variables {
    function    = "webservices"
    realm       = "nonprod"
    environment = "dev"
    project_id  = "app-nonprod"
  }

  expect_failures = [data.terraform_remote_state.platform_shared, data.terraform_remote_state.gke]
}

run "rejects_unknown_function" {
  command = plan

  variables {
    function                    = "nope"
    realm                       = "nonprod"
    environment                 = "dev"
    project_id                  = "app-nonprod"
    disable_shared_integrations = true
  }

  expect_failures = [var.function]
}
