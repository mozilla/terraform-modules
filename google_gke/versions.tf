terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.11"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.11"
    }
  }

  required_version = ">= 1.8"
}
