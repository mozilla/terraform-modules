/**
 * # Terraform Module for GCP Terraform State Storage
 * Creates GCP storage bucket which will store a project's Terraform state.
 */

resource "google_storage_bucket" "tfstate" {
  name     = "${var.name}-tf"
  location = "US"

  versioning {
    enabled = true
  }

  project = var.tfadmin_project_id

  lifecycle {
    prevent_destroy = true
  }
}
