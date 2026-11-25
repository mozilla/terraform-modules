terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 9.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 1.0, < 3.0"
    }
  }
}
