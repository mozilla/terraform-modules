terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.35"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.35"
    }
  }

  required_version = ">= 1.8"
}
