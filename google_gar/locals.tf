locals {
  repository_id = replace(coalesce(var.repository_id, "${var.application}-${var.realm}"), "/^\\d/", "")
}
