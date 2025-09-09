locals {

  final_labels = {
    # System-level labels
    domain         = var.domain # legacy "function"
    system         = var.system # legacy "application"
    component_code = var.component_code
    realm          = var.realm
    env_code       = var.env_code

    # Metadata labels
    managed_by   = "terraform"
    created_date = formatdate("YYYY-MM-DD", timestamp())
  }
}
