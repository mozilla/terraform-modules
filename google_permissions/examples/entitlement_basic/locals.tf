locals {
  application = "testapp5"
  project     = data.terraform_remote_state.projects.outputs.projects[local.application]

  // entitlement related variables
  tenant_entitlements       = data.terraform_remote_state.platform_shared.outputs.tenant_entitlements[local.application]
  google_prod_project_id    = local.tenant_entitlements.prod
  google_nonprod_project_id = local.tenant_entitlements.nonprod
  entitlement_enabled       = local.tenant_entitlements.entitlements.enabled
  entitlement_data          = local.tenant_entitlements.entitlements
}
