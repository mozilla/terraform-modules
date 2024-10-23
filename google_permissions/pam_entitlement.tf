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

  // these are the perms REQUIRED for a user to be able to approve the entitlement
  approvers_group_permissions = ["roles/privilegedaccessmanager.viewer"]
}

// we assume that PAM is enabled for the project
resource "google_privileged_access_manager_entitlement" "entitlements" {
  for_each             = var.use_entitlements && !var.admin_only ? var.entitlement_project_list : []
  entitlement_id       = var.entitlement_name
  location             = "global"
  max_request_duration = "${local.effective_request_duration}s"
  parent               = "projects/${foreach.value}"

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = module.developers_workgroup.members
  }
  privileged_access {
    gcp_iam_access {
      dynamic "role_bindings" {
        for_each = setunion(var.entitlement_role_list, local.default_admin_role_list)
        content {
          role = role_bindings.value
        }
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${foreach.value}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"
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

