data "terraform_remote_state" "platform_shared" {
  backend = "gcs"

  config = {
    bucket                      = "moz-fx-platform-terraform-state-global"
    prefix                      = "projects/platform-shared/global"
    impersonate_service_account = "tf-platform@moz-fx-websvc-terraform-admin.iam.gserviceaccount.com"
  }
}
locals {
  // this is the list of roles that we want all of the entitlements to have by default
  default_admin_role_list = [
    "roles/compute.admin",
    "roles/dns.admin",
    "roles/storage.admin",
    "roles/spanner.admin",
    "roles/cloudsql.admin",
  ]

  // this is the single set of entitlement data for the current appcode
  tenant_entitlement = data.terraform_remote_state.platform_shared.outputs.tenant_entitlements[var.appcode]
  entitlement_data = try(local.tenant_entitlement.entitlement_data.entitlements, {})


  additional_entitlements = flatten([
      for environment in ["nonprod", "prod"] : [
        for entitlement in try(local.entitlement_data.additional_entitlements, []) : {
          key = "${var.appcode}/${environment}/${entitlement.name}"
          tenant = var.appcode
          project_id = local.entitlement_data.entitlements[environment]
          entitlement = entitlement
        } if local.entitlement_data[environment] != ""
      ]
  ])

  // The maximum allowed request duration is 4 hours no matter what the user specifiesa
  // GCP allows this to be up to 12 hours, but we're going to limit it to 4 hours.
  max_allowed_request_duration = 14400

  // these are the perms REQUIRED for a user to be able to approve the entitlement
  approvers_group_permissions = ["roles/privilegedaccessmanager.viewer"]

  default_admin_entitlement_name = "admin-entitlement-01"

    # Extract distinct principals from additional entitlements
  distinct_principals = distinct(flatten([
    for entitlement in try(local.entitlement_data.additional_entitlements, []) : entitlement.principals
  ]))

  # Create the map with the hard-coded value and append the distinct principals
  entitlement_wg_map = merge(
    {
      "default" : ["workgroup:${var.appcode}/developers"] # this the default value for the default system entitlement
    },
    {
    for name, entitlement in try(local.entitlement_data.additional_entitlements, []) : entitlement.name => entitlement.principals
    }
  )

  # prep the module workgroup lookup list for the approval workflow
  # approvals on default currently NYI
  approver_wg_map = merge(
    {
      for entitlement in local.additional_entitlements : entitlement.key => entitlement.approval_workflow.principals
    }
  ) 
}


# TODO -- HOW TO DEAL WITH APPROVAL WORKGROUPS AND LOOKUP????

module "workgroup" {
  source = "../mozilla_workgroup"
  for_each = local.entitlement_wg_map
  ids = each.value
}

locals {
  module_outputs = {
    for key, mod in module.workgroup : key => mod.members
  }
}

module "approvals_workgroup" {
  source = "../mozilla_workgroup"
  for_each = local.approver_wg_map
  ids = each.value
}

locals {
  approvals_module_outputs = {
    for key, mod in module.approvals_workgroup : key => mod.members
  }
}



# now we handle the additional entitlements - these need to be created for BOTH environments
resource "google_privileged_access_manager_entitlement"  "default_prod_entitlement" {
  entitlement_id = local.default_admin_entitlement_name
  location = "global"
  max_request_duration = "${local.max_allowed_request_duration}s"
  parent               = "projects/${local.entitlement_data.prod}"

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = local.module_outputs["default"]
  }
  privileged_access {
    gcp_iam_access {
      dynamic "role_bindings" {
        for_each = setunion(try(local.entitlement_data.additional_roles, []), local.default_admin_role_list)
        content {
          role = role_bindings.value
        }
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${local.entitlement_data.prod}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"
    }
  }

# NYI for defaults
#
#  additional_notification_targets { # leave this empty for now
#    admin_email_recipients     = []
#    requester_email_recipients = []
#  }
#
#  dynamic "approval_workflow" { //optional block
#    for_each = var.number_of_approvals > 0 ? [1] : []
#    content {
#      manual_approvals {
#        require_approver_justification =  each.value.prod.entitlement. # leave this false for now
#        steps {
#          approvals_needed          = 1 # this is all that's supported by google ATM
#          approver_email_recipients = []
#          approvers {
#            principals = 
#          }
#        }
#      }
#    }
#  }
}

# now we handle the additional entitlements - these need to be created for BOTH environments
# now we handle the additional entitlements - these need to be created for BOTH environments
resource "google_privileged_access_manager_entitlement"  "default_nonprod_entitlement" {
  entitlement_id = local.default_admin_entitlement_name
  location = "global"
  max_request_duration = "${local.max_allowed_request_duration}s"
  parent               = "projects/${local.entitlement_data.nonprod}"

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = local.module_outputs["default"]
  }
  privileged_access {
    gcp_iam_access {
      dynamic "role_bindings" {
        for_each = setunion(try(local.entitlement_data.additional_roles, []), local.default_admin_role_list)
        content {
          role = role_bindings.value
        }
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${local.entitlement_data.nonprod}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"
    }
  }
# NYI for defaults
#
#  additional_notification_targets { # leave this empty for now
#    admin_email_recipients     = []
#    requester_email_recipients = []
#  }
#
#  dynamic "approval_workflow" { //optional block
#    for_each = var.number_of_approvals > 0 ? [1] : []
#    content {
#      manual_approvals {
#        require_approver_justification =  each.value.nonprod.entitlement. # leave this false for now
#        steps {
#          approvals_needed          = 1 # this is all that's supported by google ATM
#          approver_email_recipients = []
#          approvers {
#            principals = 
#          }
#        }
#      }
#    }
#  }
}

resource "google_privileged_access_manager_entitlement" "additional_entitlements" {
  for_each = {
    for entitlement in local.additional_entitlements : entitlement.key => entitlement
  }
  entitlement_id       = each.value.entitlement.name
  location             = "global"
  max_request_duration = "${local.max_allowed_request_duration}s"
  parent               = "projects/${each.value.project_id}"

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = local.module_outputs[each.value.key]
  }
  privileged_access {
    gcp_iam_access {
      dynamic "role_bindings" {
        for_each = each.value.entitlement.roles
        content {
          role = role_bindings.value
        }
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${each.value.project_id}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"
    }
  }
  dynamic "approval_workflow" { //optional block
    for_each = try(length(each.value.entitlement.approval_workflow.principals), 0) > 0 ? [1] : []
    content {
      manual_approvals {
        require_approver_justification = try(each.value.entitlement.approval_workflow.require_approver_justification, false) # leave this false for now
        steps {
          approvals_needed          = 1 # this is all that's supported by google ATM
          approver_email_recipients = []
          approvers {
            principals = local.approvals_module_outputs[each.value.key]
          }
        }
      }
    }
  }
}