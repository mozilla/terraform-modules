/*
// This file is used to add additional permissions to the project. The idea is that
// there are a set of pre-cleared permissions available for use, and that we can
// add them to the project as needed by adding them to the `other_permissions` list.
*/

//
// key: bq_job_user
//
resource "google_folder_iam_binding" "bq_job_user" {
  # This is a conditional resource, which means that it will only be created if the string is set 
  # in other_permissions AND the admin_only flag is not set.
  # 
  # NOTE: this uses bq_data_viewer as well as the next resource block so that those we grant data viewer
  # also have to execute jobs so paired with .dataViewer
  count  = contains(var.other_permissions, "bq_data_viewer") && !var.admin_only ? 1 : 0
  folder = var.google_folder_id
  role   = "roles/bigquery.jobUser"
  members = setunion(
    module.viewers_workgroup.members,
    module.developers_workgroup.members
  )
}

//
// key: bq_data_viewer
//
resource "google_folder_iam_binding" "bq_data_viewer" {
  count  = contains(var.other_permissions, "bq_data_viewer") && !var.admin_only ? 1 : 0
  folder = var.google_folder_id
  role   = "roles/bigquery.dataViewer"
  members = setunion(
    module.viewers_workgroup.members,
    module.developers_workgroup.members
  )
}

//
// key: editor_nonprod
//
resource "google_project_iam_binding" "editor_nonprod" {
  count   = contains(var.other_permissions, "editor_nonprod") && !var.admin_only && var.google_nonprod_id != "" ? 1 : 0
  project = var.google_nonprod_id
  role    = "roles/editor"
  members = module.developers_workgroup.members
}

//
// key: automl_editor_nonprod
//
resource "google_project_iam_binding" "automl_editor_prod" {
  count   = contains(var.other_permissions, "automl_editor_prod") && !var.admin_only && var.google_prod_id != "" ? 1 : 0
  project = var.google_prod_id
  role    = "roles/automl.editor"
  members = module.developers_workgroup.members
}

//
// key: cloudtranslate_editor_nonprod
//
resource "google_project_iam_member" "cloudtranslate_editor_prod" {
  for_each = contains(var.other_permissions, "cloudtranslate_editor_prod") && !var.admin_only && var.google_prod_id != "" ? toset(module.developers_workgroup.members) : toset([])
  project  = var.google_prod_id
  role     = "roles/cloudtranslate.editor"
  member   = each.key
}

//
// key: storage_objectadmin_nonprod
//
resource "google_project_iam_binding" "storage_objectadmin_prod" {
  count   = contains(var.other_permissions, "storage_objectadmin_prod") && !var.admin_only && var.google_prod_id != "" ? 1 : 0
  project = var.google_prod_id
  role    = "roles/storage.objectAdmin"
  members = module.developers_workgroup.members
}

//
// key: translationhub_admin_nonprod
//
resource "google_project_iam_binding" "translationhub_admin_prod" {
  count   = contains(var.other_permissions, "translationhub_admin_prod") && !var.admin_only && var.google_prod_id != "" ? 1 : 0
  project = var.google_prod_id
  role    = "roles/translationhub.admin"
  members = module.developers_workgroup.members
}

//
// key: bucket_admin
//
resource "google_project_iam_binding" "bucket_admin" {
  count   = contains(var.other_permissions, "nonprod_bucket_admin") && !var.admin_only && var.google_nonprod_id != "" ? 1 : 0
  project = var.google_nonprod_id
  role    = "roles/storage.admin"
  members = module.developers_workgroup.members
}

//
// key: prod_bucket_admin
//
resource "google_project_iam_binding" "prod_bucket_admin" {
  count   = contains(var.other_permissions, "prod_bucket_admin") && !var.admin_only && var.google_prod_id != "" ? 1 : 0
  project = var.google_prod_id
  role    = "roles/storage.admin"
  members = module.developers_workgroup.members
}

//
// key: prod_developer_db_admin
//
resource "google_project_iam_binding" "prod_developer_db_admin" {
  count   = contains(var.other_permissions, "prod_developer_db_admin") && !var.admin_only && var.google_prod_id != "" ? 1 : 0
  project = var.google_prod_id
  role    = "roles/cloudsql.admin"
  members = module.developers_workgroup.members
}

//
// key: nonprod_developer_db_admin
//
resource "google_project_iam_binding" "nonprod_developer_db_admin" {
  count   = contains(var.other_permissions, "nonprod_developer_db_admin") && !var.admin_only && var.google_nonprod_id != "" ? 1 : 0
  project = var.google_nonprod_id
  role    = "roles/cloudsql.admin"
  members = module.developers_workgroup.members
}

