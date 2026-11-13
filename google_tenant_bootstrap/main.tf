/**
 * # google_tenant_bootstrap
 *
 * ## GitHub immutable OIDC subjects
 *
 * GitHub repositories created after July 15, 2026, and repositories renamed or transferred after that date, use immutable OIDC subject claims.
 * Their `sub` starts with `repo:<owner>@<owner_id>/<repo>@<repo_id>` instead of `repo:<owner>/<repo>`, so an environment-scoped binding in the old form never matches.
 * This affects the artifact-writer service account trust when a GitHub environment is required.
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

module "google_gke_tenant" {
  count              = var.disable_shared_integrations ? 0 : 1
  source             = "../google_gke_tenant"
  application        = var.application
  cluster_project_id = local.gke_cluster_project_id
  environment        = var.environment
  project_id         = var.project_id
}

module "google_deployment_accounts" {
  count               = length(compact(local.github_deploy_repositories)) > 0 ? 1 : 0
  source              = "../google_deployment_accounts"
  project             = var.project_id
  environment         = var.environment
  gha_environments    = var.gha_environments
  github_repositories = local.github_deploy_repositories
  wip_name            = var.wip_name
  wip_project_number  = var.wip_project_number
}

module "gke_logging" {
  count                                 = var.disable_shared_integrations ? 0 : 1
  source                                = "../google_gke_namespace_logging"
  application                           = var.application
  environment                           = var.environment
  project                               = var.project_id
  logging_writer_service_account_member = local.logging_writer_service_account_member
  retention_days                        = var.log_retention_days
}

resource "google_service_account_iam_binding" "artifact_writer_access" {
  count              = length(local.build_principals) >= 1 ? 1 : 0
  service_account_id = local.writer_service_account_name
  role               = "roles/iam.workloadIdentityUser"
  members            = local.build_principals
}

moved {
  from = module.google_gke_tenant
  to   = module.google_gke_tenant[0]
}

moved {
  from = module.gke_logging
  to   = module.gke_logging[0]
}

moved {
  from = module.google_deployment_accounts
  to   = module.google_deployment_accounts[0]
}
