terraform {
  required_version = ">= 1.8"
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 5.10.0"
    }
    sigsci = {
      source  = "signalsciences/sigsci"
      version = ">= 3.0.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}
