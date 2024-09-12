locals {
  // this is the list of roles that we want all of the entitlements to have by default
  default_admin_role_list = [
    "roles/compute.admin",
    "roles/dns.admin",
    "roles/storage.admin",
    "roles/spanner.admin",
    "roles/cloudsql.admin",
  ]

  // The maximum allowed request duration is 4 hours no matter what the user specifiesa
  // GCP allows this to be up to 12 hours, but we're going to limit it to 4 hours.
  max_allowed_request_duration = 14400

  effective_request_duration = min(var.max_request_duration, local.max_allowed_request_duration)

  //
  // we have to do THESE shenanigans to get the resource type set correctly in our entitlement
  //

  // Extract the portion before the "/" character
  entitlement_parent_prefix = split("/", var.entitlement_parent)[0]

  // Capitalize the first letter
  entitlement_parent_capitalized = "${upper(substr(local.entitlement_parent_prefix, 0, 1))}${substr(local.entitlement_parent_prefix, 1, length(local.entitlement_parent_prefix) - 1)}"

  // Concatenate with the base string
  resource_type = "cloudresourcemanager.googleapis.com/${local.entitlement_parent_capitalized}"
}


// REALLY doesn't want this to work -- wants to nuke it regardless of the disable_on_destroy flag
resource "google_project_service" "gcp_services_nonprod_hardcode" {
       disable_on_destroy = true
       project            = "moz-fx-testapp4-nonprod"
       service            = "iam.googleapis.com"
}

// ENTITLEMENTS
variable "gcp_service_list" {
  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    //"iam.googleapis.com",
    //"container.googleapis.com",
    "privilegedaccessmanager.googleapis.com"
  ]
}

resource "google_project_service" "gcp_services_prod" {
  for_each = var.use_entitlements && !var.admin_only && length(var.google_prod_project_id) > 0 ? toset(var.gcp_service_list) : []
  project = var.google_prod_project_id
  service = each.key
  disable_on_destroy = false
  //disable_dependent_services=true
}

resource "google_project_service" "gcp_services_nonprod" {
  for_each = var.use_entitlements && !var.admin_only && length(var.google_prod_project_id) > 0 ? toset(var.gcp_service_list) : []
  project = var.google_nonprod_project_id
  service = each.key
  disable_on_destroy = false
  //disable_dependent_services=true
}


// remove these two -- iam.googleapis.com prod and nonprod. borked test. don't need in prod
// resource "google_project_service" "pam_prod" {
//   count   = var.use_entitlements && !var.admin_only && length(var.google_prod_project_id) > 0 ? 1 : 0 // check the flag and only create the module if it is true
//   project = var.google_prod_project_id
//   service = "privilegedaccessmanager.googleapis.com"
//   disable_on_destroy = false
//   disable_dependent_services=true
// }

// resource "google_project_service" "pam_nonprod" {
//   count   = var.use_entitlements && !var.admin_only && length(var.google_nonprod_project_id) > 0 ? 1 : 0 // check the flag and only create the module if it is true
//   project = var.google_nonprod_project_id
//   service = "privilegedaccessmanager.googleapis.com"
//   disable_on_destroy = false
// }

 
resource "google_privileged_access_manager_entitlement" "admin_entitlement" {
  provider             = google-beta
  count                = var.use_entitlements && !var.admin_only ? 1 : 0 // check the flag and only create the module if it is true
  entitlement_id       = var.entitlement_name
  location             = "global"
  max_request_duration = "${local.effective_request_duration}s"
  parent               = var.entitlement_parent
  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = var.entitlement_users
  }
  privileged_access {
    gcp_iam_access {
      dynamic "role_bindings" {
        for_each = setunion(var.entitlement_role_list, local.default_admin_role_list)
        content {
          role = role_bindings.value
        }
      }
      resource      = "//cloudresourcemanager.googleapis.com/${var.entitlement_parent}"
      resource_type = local.resource_type
    }
  }
  additional_notification_targets {
    admin_email_recipients     = var.admin_email_recipients
    requester_email_recipients = var.requester_email_recipients
  }

  dynamic "approval_workflow" { //optional block
    for_each = var.number_of_approvals > 0 ? [1] : []
    content {
      manual_approvals {
        require_approver_justification = var.require_approver_justification
        steps {
          approvals_needed          = var.number_of_approvals
          approver_email_recipients = var.admin_email_recipients
          approvers {
            principals = var.approver_principals
          }
        }
      }
    }
  }
}


// we want to set the roles for the users that aren't based on the entitlement, but are their baseline roles - var.user_base_additional_roles

// Iterate over user_base_additional_roles and create google_folder_iam_binding for each role
resource "google_folder_iam_binding" "user_base_roles" {
  for_each = !var.admin_only ? toset(var.user_base_additional_roles) : toset([])
  folder   = var.google_folder_id
  role     = each.value
  // apply this to ALL admins, developers, and viewers
  members = setunion(setunion(

    module.developers_workgroup.members,
    module.viewers_workgroup.members
  ), module.admins_workgroup.members)
}