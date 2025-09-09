terraform {
  required_providers {
    google_beta = {
      source  = "hashicorp/google-beta"
      # need to provide for an override here
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.0"
}