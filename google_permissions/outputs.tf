
locals {
  // This is a list of all the roles that we support in this module
  // IN ADDITION to the roles added via the core rules in main.tf
  // and that already have have existing supporting resource definitions.
  folder_additional_roles = [
    "roles/bigquery.jobUser",
  ]
  project_additional_roles = [
    "roles/automl.editor",
    "roles/cloudtranslate.editor",
    "roles/storage.objectAdmin",
    "roles/translationhub.admin",
    "roles/storage.admin",
    "roles/cloudsql.admin"
  ]
}

output "validate_folder_roles" {
  value = null
  precondition {
    condition = alltrue([
      for x in var.folder_roles : contains(local.folder_additional_roles, x)
    ])
    error_message = "You have specified an invalid folder role."
  }
}

output "validate_prod_roles" {
  value = null
  precondition {
    condition = alltrue([
      for x in var.prod_roles : contains(local.project_additional_roles, x)
    ])
    error_message = "You have specified an invalid prod role."
  }
}

output "validate_nonprod_roles" {
  value = null
  precondition {
    condition = alltrue([
      for x in var.nonprod_roles : contains(local.project_additional_roles, x)
    ])
    error_message = "You have specified an invalid nonprod role."
  }
}