terraform {
  required_version = ">= 1.8.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.32.0"
    }
  }
}
