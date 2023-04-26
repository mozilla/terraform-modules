terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.51.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.51.0"
    }
  }

  required_version = ">= 1.0"
}