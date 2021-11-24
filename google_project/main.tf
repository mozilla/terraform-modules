/**
 * # Terraform Module for Project Provisioning
 * Sets up a single GCP project linked to a billing account plus management metadata.
 */

locals {
  project_name         = "${var.project_name}-${var.realm}"
  display_name         = coalesce(var.display_name, local.project_name)
  project_generated_id = "${format("%.25s", "moz-fx-${local.project_name}")}-${random_id.project.hex}"
  project_id           = coalesce(var.project_id, local.project_generated_id)

  app_code       = coalesce(var.app_code, var.project_name)
  component_code = coalesce(var.component_code, "${local.app_code}-uncat")
  env_code       = coalesce(var.env_code, var.realm)
}

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

  labels = {
    app            = var.project_name
    app_code       = local.app_code
    component_code = local.component_code
    cost_center    = var.cost_center
    program_code   = var.program_code
    program_name   = var.program_name
  }

  lifecycle {
    prevent_destroy = true
  }
}
