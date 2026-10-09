data "terraform_remote_state" "platform_shared" {
  count   = var.disable_shared_integrations ? 0 : 1
  backend = "gcs"

  lifecycle {
    precondition {
      condition     = var.risk_level != null
      error_message = "risk_level is required unless disable_shared_integrations is set."
    }
  }

  config = {
    bucket                      = "moz-fx-platform-terraform-state-global"
    prefix                      = "projects/platform-shared/global"
    impersonate_service_account = local.terraform_service_account
  }
}

data "terraform_remote_state" "gke" {
  count   = var.disable_shared_integrations ? 0 : 1
  backend = "gcs"

  lifecycle {
    precondition {
      condition     = var.risk_level != null
      error_message = "risk_level is required unless disable_shared_integrations is set."
    }
  }

  config = {
    bucket                      = "moz-fx-platform-terraform-state-global"
    prefix                      = "projects/${local.cluster}/${var.realm}"
    impersonate_service_account = local.terraform_service_account
  }
}

data "terraform_remote_state" "vpc" {
  count   = var.disable_shared_integrations ? 0 : 1
  backend = "gcs"

  config = {
    bucket                      = "moz-fx-platform-mgmt-global-tf"
    prefix                      = "projects/functional-org-vpc"
    impersonate_service_account = local.terraform_service_account
  }
}

data "terraform_remote_state" "projects" {
  backend = "gcs"

  config = {
    bucket                      = "moz-fx-${var.function}-terraform-state-global"
    prefix                      = "projects/projects/global"
    impersonate_service_account = local.terraform_service_account
  }
}
