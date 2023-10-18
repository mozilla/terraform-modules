terraform {
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 5.2"
    }

    random = {
      source = "hashicorp/random"
    }
  }

  required_version = ">= 1.0"
}
