terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "> 6.0, < 8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "> 2.0, < 4.0"
    }
  }
}
