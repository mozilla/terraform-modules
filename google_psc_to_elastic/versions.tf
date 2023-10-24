terraform {
  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "~> 0.9.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.27"
    }
  }
  required_version = ">= 1.0"
}
