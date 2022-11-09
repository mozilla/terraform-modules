terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.42, < 5"
    }
  }
  required_version = ">= 0.13"
}
