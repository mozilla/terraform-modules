locals {
  parent_zone = "${var.realm}.${var.team_name}.mozgcp.net"
  dns_name    = "${var.app_name}.${local.parent_zone}."
  # https://cloud.google.com/dns/docs/error-messages
  # The operation to create a managed zone can fail with this error if the
  # managed zone name does not begin with a letter, end with a letter or digit,
  # and contain only lowercase letters, digits, or dashes.
  zone_name = replace("${var.app_name}-${var.realm}-${var.team_name}-mozgcp-net", "/^\\d/", "")
}
