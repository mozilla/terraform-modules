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
  entitlement_parent_capitalized = upper(substr(local.entitlement_parent_prefix, 0, 1)) + substr(local.entitlement_parent_prefix, 1, length(local.entitlement_parent_prefix) - 1)

  // Concatenate with the base string
  resource_type = "cloudresourcemanager.googleapis.com/" + local.entitlement_parent_capitalized
}

resource "google_privileged_access_manager_entitlement" "admin_entitlement" {
    entitlement_id = var.entitlement_name
    location = "global"
    max_request_duration = "${local.effective_request_duration}s"
    parent = var.entitlement_parent
    requester_justification_config {    
        unstructured{}
    }

    eligible_users {
      principals = var.entitlement_users 
    }
    privileged_access{
        gcp_iam_access{
            dynamic "role_bindings" {
              for_each = setunion(var.entitlement_role_list, default_admin_role_list)
              content {
                role = role_bindings.value
              }
            }
            resource = "//cloudresourcemanager.googleapis.com/${var.entitlement_parent}"
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
