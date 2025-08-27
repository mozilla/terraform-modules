terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      # need to provide for an override here
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = var.credentials

  # Configure service account impersonation if specified
  impersonate_service_account = var.impersonate_service_account

  # Apply the computed default labels to all resources
  default_labels = local.final_labels
}
