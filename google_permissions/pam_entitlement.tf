
locals {
  // this is the list of roles that we want all of the entitlements to have by default
  default_admin_role_list = [
    "roles/compute.admin",
    "roles/dns.admin",
    "roles/storage.admin",
    "roles/spanner.admin",
    "roles/cloudsql.admin",
  ]

  // Populate the environments list dynamically
  environments = [
    for environment in ["nonprod", "prod"] : environment
    if(environment == "nonprod" && var.google_nonprod_project_id != "") || (environment == "prod" && var.google_prod_project_id != "")
  ]

  additional_entitlements = flatten([
    for environment in local.environments : [
      for entitlement in try(var.entitlement_data.additional_entitlements, []) : {
        key         = "${var.app_code}/${environment}/${entitlement.name}"
        tenant      = var.app_code
        project_id  = environment == "nonprod" ? var.google_nonprod_project_id : var.google_prod_project_id
        entitlement = entitlement
      }
    ]
  ])

  // The maximum allowed request duration is 4 hours no matter what the user specifies
  // GCP allows this to be up to 12 hours, but we're going to limit it to 4 hours.
  max_allowed_request_duration = 14400

  // these are the perms REQUIRED for a user to be able to approve the entitlement
  approvers_group_permissions = ["roles/privilegedaccessmanager.viewer"]

  default_admin_entitlement_name = "admin-entitlement-01"

  # Create the map with the hard-coded value and append the distinct principals
  entitlement_wg_map = var.app_code != "" ? merge(
    {
      "default" : ["workgroup:${var.app_code}/developers"] # this the default value for the default system entitlement
    },
    {
      for name, add_entitlement in try(local.additional_entitlements, []) : add_entitlement.key => add_entitlement.entitlement.principals
    }
  ) : {}

  # prep the module workgroup lookup list for the approval workflow
  # approvals on default currently NYI
  approver_wg_map = {
    for e in try(local.additional_entitlements, []) :
    e.key => e.entitlement.approval_workflow.principals
    if can(e.entitlement.approval_workflow) && e.entitlement.approval_workflow != null
  }
}

module "workgroup" {
  source   = "../mozilla_workgroup"
  for_each = local.entitlement_wg_map
  ids      = each.value
}

locals {
  module_outputs = {
    for key, mod in module.workgroup : key => mod.members
  }
}

module "approvals_workgroup" {
  source   = "../mozilla_workgroup"
  for_each = local.approver_wg_map
  ids      = each.value
}

locals {
  approvals_module_outputs = {
    for key, mod in module.approvals_workgroup : key => mod.members
  }
}



# now we handle the additional entitlements - these need to be created for BOTH environments
resource "google_privileged_access_manager_entitlement" "default_prod_entitlement" {
  count                = var.entitlement_enabled && (var.google_prod_project_id != "") ? 1 : 0
  entitlement_id       = local.default_admin_entitlement_name
  location             = "global"
  max_request_duration = "${local.max_allowed_request_duration}s"
  parent               = "projects/${var.google_prod_project_id}"

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = local.module_outputs["default"].members
  }
  privileged_access {
    gcp_iam_access {
      dynamic "role_bindings" {
        for_each = setunion(try(var.entitlement_data.additional_roles, []), local.default_admin_role_list)
        content {
          role = role_bindings.value
        }
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${var.google_prod_project_id}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"
    }
  }

  # NYI for defaults - need to add to the schema.json file
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
resource "google_privileged_access_manager_entitlement" "default_nonprod_entitlement" {
  count                = var.entitlement_enabled && (var.google_nonprod_project_id != "") ? 1 : 0
  entitlement_id       = local.default_admin_entitlement_name
  location             = "global"
  max_request_duration = "${local.max_allowed_request_duration}s"
  parent               = "projects/${var.google_nonprod_project_id}"

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = local.module_outputs["default"]
  }
  privileged_access {
    gcp_iam_access {
      dynamic "role_bindings" {
        for_each = setunion(try(var.entitlement_data.additional_roles, []), local.default_admin_role_list)
        content {
          role = role_bindings.value
        }
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${var.google_nonprod_project_id}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"
    }
  }
  # NYI for defaults - need to add to the schema.json file
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
  for_each = var.entitlement_enabled ? {
    for entitlement in local.additional_entitlements : entitlement.key => entitlement
  } : {}
  entitlement_id       = each.value.entitlement.name
  location             = "global"
  max_request_duration = "${local.max_allowed_request_duration}s"
  parent               = "projects/${each.value.project_id}"

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = local.module_outputs[each.key]
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
            principals = local.approvals_module_outputs[each.key]
          }
        }
      }
    }
  }
}

# Create a feed that sends notifications about network resource updates.
resource "google_cloud_asset_project_feed" "project_feed" {
  for_each     = var.entitlement_enabled && var.entitlement_slack_topic != "" ? toset(local.environments) : []
  project      = local.environments[each.key]
  feed_id      = var.feed_id
  content_type = "RESOURCE"

  asset_types = [
    "privilegedaccessmanager.googleapis.com/Grant",
  ]

  feed_output_config {
    pubsub_destination {
      topic = var.entitlement_slack_topic
    }
  }
}
