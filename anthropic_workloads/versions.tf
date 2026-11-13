terraform {
  required_version = ">= 1.9"

  required_providers {
    anthropic = {
      source  = "mozilla/anthropic"
      version = ">= 0.1.0, < 1.0.0"
    }
  }
}
