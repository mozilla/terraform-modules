locals {
  parent_zone = "${var.realm}.${var.team_name}.mozgcp.net"
  dns_name    = "${var.app_name}.${local.parent_zone}."
  zone_name   = "${var.app_name}-${var.realm}-${var.team_name}-mozgcp-net"
}
