terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.0, < 7.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "> 6.0, < 8.0"
    }
  }
}
