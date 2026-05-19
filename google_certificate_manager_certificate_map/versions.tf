terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0, < 4.0"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
  }
}
