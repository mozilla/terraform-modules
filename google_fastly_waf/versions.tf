terraform {
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "~> 9.0"
    }
    sigsci = {
      source  = "signalsciences/sigsci"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}
