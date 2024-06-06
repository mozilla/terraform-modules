terraform {
  required_version = ">= 1.8.3"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.2"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 5.32.0"
    }
  }
}
