terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37"
    }
  }
  required_version = "~> 1.0"
}
