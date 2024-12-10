module "permissions" {
  source = "github.com/mozilla/terraform-modules//google_permissions"
  //source = "../google_permissions"

  // the appcode (aka application or tenant name) is used to create the workgroups and entitlements if used
  app_code = local.application

  entitlement_enabled = local.entitlement_enabled
  entitlement_data    = local.entitlement_data

  google_folder_id = local.project.folder.id

  //
  // We pull these from the remote state data now
  // which sources it as the realms from the tenant yaml
  //
  // google_prod_project_id    = local.project["prod"].id -- this one doesn't have prod
  // google_nonprod_project_id = local.project["nonprod"].id

  // if you want to send to slack
  //entitlement_slack_topic = local.entitlement_slack_pubsub_topic

  // in this case -- all three of these workgroups will be given the basic user permissions in the folder
  admin_ids     = ["workgroup:${local.application}/admins"]
  developer_ids = ["workgroup:${local.application}/developers"]
  viewer_ids    = ["workgroup:${local.application}/viewers"]

}
