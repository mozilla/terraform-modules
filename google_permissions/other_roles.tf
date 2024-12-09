/*
// This file is used to add additional roles to the project. The idea is that
// there are a set of pre-cleared roles available for use, and that we can
// add them to the project as needed by adding them to the appropriate list
// for the env targeted (prod or nonprod).
//
*/

resource "google_folder_iam_binding" "bq_job_user" {
  //
  // NOTE: this uses bq_data_viewer as well as the next resource block so that those we grant data viewer
  // also have to execute jobs so paired with .dataViewer
  count  = contains(var.folder_roles, "roles/bigquery.jobUser") && !var.admin_only && var.entitlement_enabled ? 1 : 0
  folder = var.google_folder_id
  role   = "roles/bigquery.jobUser"
  members = setunion(
    module.viewers_workgroup.members,
    module.developers_workgroup.members
  )
}

resource "google_folder_iam_binding" "bq_data_viewer" {
  count  = contains(var.folder_roles, "roles/bigquery.dataViewer") && !var.admin_only && var.entitlement_enabled ? 1 : 0
  folder = var.google_folder_id
  role   = "roles/bigquery.dataViewer"
  members = setunion(
    module.viewers_workgroup.members,
    module.developers_workgroup.members
  )
}

# roles/redis.admin as folder_role

resource "google_folder_iam_binding" "developers_redis_admin" {
  count   = contains(var.folder_roles, "roles/redis.admin") && !var.admin_only && var.entitlement_enabled ? 1 : 0
  folder  = var.google_folder_id
  role    = "roles/redis.admin"
  members = module.developers_workgroup.members

}

# roles/logging.admin as folder_role

resource "google_folder_iam_binding" "developers_logging_admin" {
  count   = contains(var.folder_roles, "roles/logging.admin") && !var.admin_only && var.entitlement_enabled ? 1 : 0
  folder  = var.google_folder_id
  role    = "roles/logging.admin"
  members = module.developers_workgroup.members

}

# roles/monitoring.alertPolicyEditor as folder_role

resource "google_folder_iam_binding" "developers_monitoring_alertPolicyEditor" {
  count   = contains(var.folder_roles, "roles/monitoring.alertPolicyEditor") && !var.admin_only && var.entitlement_enabled ? 1 : 0
  folder  = var.google_folder_id
  role    = "roles/monitoring.alertPolicyEditor"
  members = module.developers_workgroup.members

}

# roles/monitoring.notificationChannelEditor in as folder_role

resource "google_folder_iam_binding" "developers_monitoring_notificationChannelEditor" {
  count   = contains(var.folder_roles, "roles/monitoring.notificationChannelEditor") && !var.admin_only && var.entitlement_enabled ? 1 : 0
  folder  = var.google_folder_id
  role    = "roles/monitoring.notificationChannelEditor"
  members = module.developers_workgroup.members

}

resource "google_project_iam_binding" "editor_nonprod" {
  count   = contains(var.nonprod_roles, "roles/editor") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/editor"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "automl_editor_prod" {
  count   = contains(var.prod_roles, "roles/automl.editor") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/automl.editor"
  members = module.developers_workgroup.members
}

resource "google_project_iam_member" "cloudtranslate_editor_prod" {
  for_each = contains(var.prod_roles, "roles/cloudtranslate.editor") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? toset(module.developers_workgroup.members) : toset([])
  project  = var.google_prod_project_id
  role     = "roles/cloudtranslate.editor"
  member   = each.key
}

resource "google_project_iam_binding" "storage_objectadmin_prod" {
  count   = contains(var.prod_roles, "roles/storage.objectAdmin") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/storage.objectAdmin"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "translationhub_admin_prod" {
  count   = contains(var.prod_roles, "roles/translationhub.admin") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/translationhub.admin"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "bucket_admin" {
  count   = contains(var.nonprod_roles, "roles/storage.admin") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/storage.admin"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "prod_bucket_admin" {
  count   = contains(var.prod_roles, "roles/storage.admin") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/storage.admin"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "prod_developer_db_admin" {
  count   = contains(var.prod_roles, "roles/cloudsql.admin") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/cloudsql.admin"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "nonprod_developer_db_admin" {
  count   = contains(var.nonprod_roles, "roles/cloudsql.admin") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/cloudsql.admin"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "prod_developer_monitoring_uptimecheckconfigeditor" {
  count   = contains(var.prod_roles, "roles/monitoring.uptimeCheckConfigEditor") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/monitoring.uptimeCheckConfigEditor"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "nonprod_developer_monitoring_uptimecheckconfigeditor" {
  count   = contains(var.nonprod_roles, "roles/monitoring.uptimeCheckConfigEditor") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/monitoring.uptimeCheckConfigEditor"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "prod_developer_pubsub_editor" {
  count   = contains(var.prod_roles, "roles/pubsub.editor") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/pubsub.editor"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "nonprod_developer_pubsub_editor" {
  count   = contains(var.nonprod_roles, "roles/pubsub.editor") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/pubsub.editor"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "prod_developer_colabEnterpriseUser" {
  count   = contains(var.prod_roles, "roles/aiplatform.colabEnterpriseUser") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/aiplatform.colabEnterpriseUser"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "nonprod_developer_colabEnterpriseUser" {
  count   = contains(var.nonprod_roles, "roles/aiplatform.colabEnterpriseUser") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/aiplatform.colabEnterpriseUser"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "prod_developer_cloudsql_viewer" {
  count   = contains(var.prod_roles, "roles/cloudsql.viewer") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/cloudsql.viewer"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "nonprod_developer_cloudsql_viewer" {
  count   = contains(var.nonprod_roles, "roles/cloudsql.viewer") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/cloudsql.viewer"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "prod_developer_objectUser" {
  count   = contains(var.prod_roles, "roles/storage.objectUser") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? 1 : 0
  project = var.google_prod_project_id
  role    = "roles/storage.objectUser"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "nonprod_developer_objectUser" {
  count   = contains(var.nonprod_roles, "roles/storage.objectUser") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/storage.objectUser"
  members = module.developers_workgroup.members
}

resource "google_project_iam_binding" "nonprod_developer_secretmanager_admin" {
  count   = contains(var.nonprod_roles, "roles/secretmanager.admin") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/secretmanager.admin"
  members = module.developers_workgroup.members
}

resource "google_project_iam_member" "prod_developer_secretmanager_secretAccessor" {
  for_each = contains(var.prod_roles, "roles/secretmanager.secretAccessor") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? toset(module.developers_workgroup.members) : toset([])
  project  = var.google_prod_project_id
  role     = "roles/secretmanager.secretAccessor"
  member   = each.value
}

resource "google_project_iam_member" "prod_developer_secretmanager_secretVersionAdder" {
  for_each = contains(var.prod_roles, "roles/secretmanager.secretVersionAdder") && !var.admin_only && var.entitlement_enabled && var.google_prod_project_id != "" ? toset(module.developers_workgroup.members) : toset([])
  project  = var.google_prod_project_id
  role     = "roles/secretmanager.secretVersionAdder"
  member   = each.value
}

resource "google_project_iam_binding" "nonprod_developer_oath_config_editor" {
  count   = contains(var.nonprod_roles, "roles/oauthconfig.editor") && !var.admin_only && var.entitlement_enabled && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/oauthconfig.editor"
  members = module.developers_workgroup.members
}
