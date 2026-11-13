/**
 * # google_agent_platform
 *
 * ## GitHub immutable OIDC subjects
 *
 * GitHub repositories created after July 15, 2026, and repositories renamed or transferred after that date, use immutable OIDC subject claims.
 * Their `sub` starts with `repo:<owner>@<owner_id>/<repo>@<repo_id>` instead of `repo:<owner>/<repo>`, so an environment-scoped binding in the old form never matches.
 * This affects the deployer service account trust when a GitHub environment is required.
 *
 * To check a repository and get its prefix, run:
 *
 * ```sh
 * gh api repos/<owner>/<repo>/actions/oidc/customization/sub
 * ```
 *
 * When `use_immutable_subject` is `true`, add the `sub_claim_prefix` value to `github_subject_prefixes`:
 *
 * ```hcl
 * github_subject_prefixes = {
 *   "example-org/example-repo" = "repo:example-org@123456/example-repo@456789"
 * }
 * ```
 *
 * See [Immutable subject claims](https://docs.github.com/en/actions/reference/security/oidc#immutable-subject-claims) in the GitHub docs.
 */

data "google_project" "this" {
  project_id = var.project_id
}

# Deployer

resource "google_service_account" "deployer" {
  account_id   = "agent-deployer-${var.environment}"
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

resource "google_project_iam_member" "deployer_engine_deployer" {
  project = var.project_id
  role    = local.engine_deployer_role
  member  = google_service_account.deployer.member
}

# Runtime

resource "google_service_account" "runtime" {
  count        = var.create_runtime_service_account ? 1 : 0
  account_id   = "agent-runtime-${var.environment}"
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
  account_id   = "agent-caller-${var.environment}"
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

resource "google_project_iam_member" "caller_engine_caller" {
  count   = length(local.caller_principals) > 0 ? 1 : 0
  project = var.project_id
  role    = local.engine_caller_role
  member  = google_service_account.caller[0].member
}
