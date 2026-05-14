terraform {
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "> 8.0, < 10.0"
    }
    sigsci = {
      source  = "signalsciences/sigsci"
      version = "> 2.0, < 4.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "> 6.0, < 8.0"
    }
  }
}
