terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.5, < 8.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.0, < 8.0"
    }
  }
}
