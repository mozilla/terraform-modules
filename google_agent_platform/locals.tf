locals {
  wip_id = "projects/${var.wip_project_number}/locations/global/workloadIdentityPools/${var.wip_name}"

  deploy_principals = [
    for repo in var.deploy_repositories : var.deploy_github_environment != null ?
    "principal://iam.googleapis.com/${local.wip_id}/subject/${lookup(var.github_subject_prefixes, repo, "repo:${repo}")}:environment:${var.deploy_github_environment}" :
    "principalSet://iam.googleapis.com/${local.wip_id}/attribute.repository/${repo}"
  ]

  caller_principals = [
    for repo in var.caller_repositories :
    "principalSet://iam.googleapis.com/${local.wip_id}/attribute.repository/${repo}"
  ]

  agent_identity_principal = "principalSet://agents.global.org-${var.gcp_organization_id}.system.id.goog/attribute.platformContainer/aiplatform/projects/${data.google_project.this.number}"
  reasoning_engine_agent   = "serviceAccount:service-${data.google_project.this.number}@gcp-sa-aiplatform-re.iam.gserviceaccount.com"

  engine_deployer_role = "organizations/${var.gcp_organization_id}/roles/AgentEngineDeployer"
  engine_caller_role   = "organizations/${var.gcp_organization_id}/roles/AgentEngineCaller"

  runtime_members = merge(
    { agent_identity = local.agent_identity_principal },
    var.create_runtime_service_account ? { runtime_service_account = google_service_account.runtime[0].member } : {},
  )
}
