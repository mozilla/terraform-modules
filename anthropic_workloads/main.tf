/**
 * # anthropic_workloads
 *
 * Service accounts and federation rules that let workloads call the Anthropic API with their own OIDC token instead of an API key.
 *
 * Issuers and workspaces are created elsewhere and passed in by ID. The provider must authenticate with an `org:admin` token.
 */

resource "anthropic_service_account" "workloads" {
  for_each          = var.workloads
  name              = each.key
  organization_role = "developer"
}

resource "anthropic_service_account_workspace" "workloads" {
  for_each           = var.workloads
  service_account_id = anthropic_service_account.workloads[each.key].id
  workspace_id       = each.value.workspace_id
  workspace_role     = "workspace_user"
}

resource "anthropic_federation_rule" "workloads" {
  for_each           = var.workloads
  name               = each.key
  issuer_id          = each.value.issuer_id
  service_account_id = anthropic_service_account.workloads[each.key].id
  oauth_scope        = "workspace:inference"
  workspace_ids      = [each.value.workspace_id]
  match = {
    audience = var.audience
    claims   = each.value.claims
  }
}
