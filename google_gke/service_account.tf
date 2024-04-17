#
# Service Account Setup
#
locals {
  registry_projects_list = length(var.registry_project_ids) == 0 ? [local.project_id] : var.registry_project_ids
}

resource "google_service_account" "cluster_service_account" {
  account_id   = var.service_account_id == null ? "gke-${local.cluster_name}" : var.service_account_id
  display_name = "Terraform-managed service account for cluster ${local.cluster_name}"
  project      = local.project_id
}

resource "google_project_iam_member" "cluster_service_account-defaults" {
  for_each = toset(var.node_pool_sa_roles)

  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
  project = local.project_id
  role    = each.key
}

resource "google_project_iam_member" "cluster_service_account-gar" {
  for_each = var.grant_registry_access ? toset(local.registry_projects_list) : []

  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
  project = each.key
  role    = "roles/artifactregistry.reader"
}

resource "google_project_iam_member" "cluster_service_account-gcr" {
  for_each = var.grant_registry_access ? toset(local.registry_projects_list) : []

  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
  project = each.key
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "cluster_service_account-gcfs" {
  count   = var.enable_gcfs ? 1 : 0
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
  project = local.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"
}
