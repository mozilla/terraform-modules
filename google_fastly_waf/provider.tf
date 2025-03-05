# NGWAF SIGSCI
provider "sigsci" {
  corp     = var.ngwaf_corp
  email    = var.ngwaf_email
  password = "not_a_real_password_set_for_terraform_validate" # pragma: allowlist secret
}
