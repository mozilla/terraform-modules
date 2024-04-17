terraform {
  required_version = "~> 1.4.6"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
