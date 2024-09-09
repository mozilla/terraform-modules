
module "google_permissions" {
    source                    = "../../google_permissions"
    //source                    = "github.com/mozilla/terraform-modules//google_permissions?ref=main"

    // this is mutually exclusive with the older mode of granting roles, especially the granting of "owner" role
    create_entitlements       = true

    // we still use this to specify the scope of our entitlement UNLESS we explicitly set entitlement_parent
    // relevant code: entitlement_parent = coalesce(var.entitlement_parent, var.google_folder_id)
    //
    google_folder_id          = local.project.folder.id

    // still need these two so we can enable the API for each project in the folder
    google_prod_project_id    = local.project["prod"].id
    google_nonprod_project_id = local.project["nonprod"].id


    // in this case -- all three of these workgroups will be given the basic user permissions in the folder
    admin_ids                 = ["workgroup:${local.application}/admins"]
    developer_ids             = ["workgroup:${local.application}/developers"]
    viewer_ids                = ["workgroup:${local.application}/viewers"]

    // if we leave entitlement_name blank here, it'll default to - admin-entitlement-01
    // which should be fine for most cases as in our current model, we don't expect there to be multiple entitlements per tenant
    entitlement_name          = "admin-entitlement-01"

    // entitlement_parent isn't set so it uses the folder id

    // these are the roles that will be applied to the entitlement - it may make sense to have a separate group in workgroup?
    entitlement_users         = ["workgroup:${local.application}/developers"]
}