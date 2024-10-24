terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=6.7.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=6.7.0"
    }
  }
  required_version = "~> 1.2"
}