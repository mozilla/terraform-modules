terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.0"
    }

    google-beta = {
      source = "hashicorp/google-beta"
      version = "6.0.1"
    }
  }
  required_version = "~> 1.2"
}