/**
 * # Terraform Module for Project Provisioning
 * Sets up a single GCP project linked to a billing account plus management metadata.
 */

resource "random_id" "project" {
  byte_length = 2
}

resource "google_project" "project" {
  name        = local.display_name
  project_id  = local.project_id
  skip_delete = true

  billing_account = var.billing_account_id
  folder_id       = var.parent_id

  auto_create_network = false

  labels = local.all_project_labels

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "project" {
  for_each           = toset(var.project_services)
  project            = local.project_id
  service            = each.key
  disable_on_destroy = false
}