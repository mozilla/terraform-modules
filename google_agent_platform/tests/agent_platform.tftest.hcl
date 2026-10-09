mock_provider "google" {
  mock_data "google_project" {
    defaults = {
      number = "111111111111"
    }
  }

  mock_resource "google_service_account" {
    defaults = {
      email  = "agent-sa@app-nonprod.iam.gserviceaccount.com"
      member = "serviceAccount:agent-sa@app-nonprod.iam.gserviceaccount.com"
      name   = "projects/app-nonprod/serviceAccounts/agent-sa@app-nonprod.iam.gserviceaccount.com"
    }
  }
}

variables {
  application         = "app"
  project_id          = "app-nonprod"
  deploy_repositories = ["example-org/agents"]
  gcp_organization_id = 222222222222
  wip_project_number  = 333333333333
}

run "nonprod_defaults" {
  command = plan

  variables {
    environment    = "dev"
    secret_readers = ["group:devs@example.com"]
  }

  assert {
    condition     = one(google_service_account_iam_binding.deployer_wif[0].members) == "principalSet://iam.googleapis.com/projects/333333333333/locations/global/workloadIdentityPools/github-actions/attribute.repository/example-org/agents"
    error_message = "Nonprod deploys must be scoped to the repository."
  }

  assert {
    condition     = keys(google_project_iam_member.runtime_aiplatform_user) == ["agent_identity"]
    error_message = "Only the Agent Identity set gets runtime roles by default."
  }

  assert {
    condition     = google_project_iam_member.runtime_aiplatform_user["agent_identity"].member == "principalSet://agents.global.org-222222222222.system.id.goog/attribute.platformContainer/aiplatform/projects/111111111111"
    error_message = "Agent Identity principal must cover the whole project."
  }

  assert {
    condition     = google_secret_manager_secret_iam_binding.agents_accessor.members == toset(["principalSet://agents.global.org-222222222222.system.id.goog/attribute.platformContainer/aiplatform/projects/111111111111", "group:devs@example.com"])
    error_message = "Secret readers must be Agent Identity plus secret_readers."
  }

  assert {
    condition     = google_secret_manager_secret.agents.secret_id == "dev-app-secrets"
    error_message = "Secret must be named <environment>-<application>-secrets."
  }

  assert {
    condition     = length(google_service_account.runtime) == 0 && length(google_service_account.caller) == 0 && length(google_artifact_registry_repository_iam_member.reasoning_engine_image_reader) == 0
    error_message = "Optional resources must be off by default."
  }
}

run "prod_requires_github_environment" {
  command = plan

  variables {
    environment               = "prod"
    deploy_github_environment = "prod"
  }

  assert {
    condition     = one(google_service_account_iam_binding.deployer_wif[0].members) == "principal://iam.googleapis.com/projects/333333333333/locations/global/workloadIdentityPools/github-actions/subject/repo:example-org/agents:environment:prod"
    error_message = "Prod deploys must be scoped to the GitHub environment."
  }
}

run "optional_resources" {
  command = plan

  variables {
    environment                    = "dev"
    create_runtime_service_account = true
    caller_repositories            = ["example-org/caller"]
    image_repository = {
      project  = "app-nonprod"
      location = "us"
      name     = "app-nonprod"
    }
  }

  assert {
    condition     = length(google_service_account.runtime) == 1 && length(google_service_account_iam_member.deployer_acts_as_runtime) == 1
    error_message = "Runtime service account and deployer actAs must be created."
  }

  assert {
    condition     = toset(keys(google_project_iam_member.runtime_log_writer)) == toset(["agent_identity", "runtime_service_account"])
    error_message = "Runtime service account must get the baseline roles."
  }

  assert {
    condition     = length(google_service_account.caller) == 1 && length(google_project_iam_custom_role.engine_caller) == 1
    error_message = "Caller resources must be created when caller_repositories is set."
  }

  assert {
    condition     = google_artifact_registry_repository_iam_member.reasoning_engine_image_reader[0].member == "serviceAccount:service-111111111111@gcp-sa-aiplatform-re.iam.gserviceaccount.com"
    error_message = "Image read must go to the Reasoning Engine service agent."
  }
}

run "no_deploy_repositories" {
  command = plan

  variables {
    environment         = "dev"
    deploy_repositories = []
  }

  assert {
    condition     = length(google_service_account_iam_binding.deployer_wif) == 0
    error_message = "No WIF binding without deploy repositories."
  }
}
