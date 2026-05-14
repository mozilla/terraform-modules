terraform {
  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "> 0.11, < 0.13"
    }
    google = {
      source  = "hashicorp/google"
      version = "> 6.0, < 8.0"
    }
  }
}
