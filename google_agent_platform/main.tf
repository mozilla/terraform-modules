data "google_project" "this" {
  project_id = var.project_id
}

# Deployer

resource "google_service_account" "deployer" {
  account_id   = "agent-deployer"
  project      = var.project_id
  display_name = "Agent Platform deployer"
  description  = "Assumed by CI to create and update Agent Platform reasoningEngines."
}

resource "google_service_account_iam_binding" "deployer_wif" {
  count              = length(local.deploy_principals) > 0 ? 1 : 0
  service_account_id = google_service_account.deployer.name
  role               = "roles/iam.workloadIdentityUser"
  members            = local.deploy_principals
}

resource "google_project_iam_custom_role" "engine_deployer" {
  role_id     = "agentEngineDeployer"
  project     = var.project_id
  title       = "Agent Engine Deployer"
  description = "Create, update and smoke-test Agent Platform reasoningEngines and their sandbox templates."
  permissions = [
    "aiplatform.reasoningEngines.create",
    "aiplatform.reasoningEngines.delete",
    "aiplatform.reasoningEngines.get",
    "aiplatform.reasoningEngines.list",
    "aiplatform.reasoningEngines.query",
    "aiplatform.reasoningEngines.update",
    "aiplatform.sandboxEnvironmentTemplates.create",
    "aiplatform.sandboxEnvironmentTemplates.get",
    "aiplatform.sandboxEnvironmentTemplates.list",
  ]
}

resource "google_project_iam_member" "deployer_engine_deployer" {
  project = var.project_id
  role    = google_project_iam_custom_role.engine_deployer.id
  member  = google_service_account.deployer.member
}

# Runtime

resource "google_service_account" "runtime" {
  count        = var.create_runtime_service_account ? 1 : 0
  account_id   = "agent-runtime"
  project      = var.project_id
  display_name = "Agent Platform runtime"
  description  = "Shared runtime identity for agents deployed with service_account instead of Agent Identity."
}

resource "google_service_account_iam_member" "deployer_acts_as_runtime" {
  count              = var.create_runtime_service_account ? 1 : 0
  service_account_id = google_service_account.runtime[0].name
  role               = "roles/iam.serviceAccountUser"
  member             = google_service_account.deployer.member
}

resource "google_project_iam_member" "runtime_aiplatform_user" {
  for_each = local.runtime_members
  project  = var.project_id
  role     = "roles/aiplatform.user"
  member   = each.value
}

resource "google_project_iam_member" "runtime_log_writer" {
  for_each = local.runtime_members
  project  = var.project_id
  role     = "roles/logging.logWriter"
  member   = each.value
}

resource "google_artifact_registry_repository_iam_member" "reasoning_engine_image_reader" {
  count      = var.image_repository != null ? 1 : 0
  project    = var.image_repository.project
  location   = var.image_repository.location
  repository = var.image_repository.name
  role       = "roles/artifactregistry.reader"
  member     = local.reasoning_engine_agent
}

# Secrets

resource "google_secret_manager_secret" "agents" {
  secret_id = "${var.environment}-${var.application}-secrets"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "agents" {
  secret      = google_secret_manager_secret.agents.id
  secret_data = "{}"

  lifecycle {
    ignore_changes = [secret_data]
  }
}

resource "google_secret_manager_secret_iam_binding" "agents_accessor" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.agents.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members   = setunion(values(local.runtime_members), var.secret_readers)
}

# Caller

resource "google_service_account" "caller" {
  count        = length(local.caller_principals) > 0 ? 1 : 0
  account_id   = "agent-caller"
  project      = var.project_id
  display_name = "Agent Platform caller"
  description  = "Assumed by CI to invoke Agent Platform reasoningEngines."
}

resource "google_service_account_iam_binding" "caller_wif" {
  count              = length(local.caller_principals) > 0 ? 1 : 0
  service_account_id = google_service_account.caller[0].name
  role               = "roles/iam.workloadIdentityUser"
  members            = local.caller_principals
}

resource "google_project_iam_custom_role" "engine_caller" {
  count       = length(local.caller_principals) > 0 ? 1 : 0
  role_id     = "agentEngineCaller"
  project     = var.project_id
  title       = "Agent Engine Caller"
  description = "Invoke Agent Platform reasoningEngines."
  permissions = [
    "aiplatform.reasoningEngines.get",
    "aiplatform.reasoningEngines.query",
  ]
}

resource "google_project_iam_member" "caller_engine_caller" {
  count   = length(local.caller_principals) > 0 ? 1 : 0
  project = var.project_id
  role    = google_project_iam_custom_role.engine_caller[0].id
  member  = google_service_account.caller[0].member
}
