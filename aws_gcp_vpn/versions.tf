terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.41"
    }
  }
}
