terraform {
  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "~> 0.12"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}
