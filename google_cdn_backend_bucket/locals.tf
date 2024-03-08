locals {
  name_prefix = coalesce(var.name_prefix, format("%s-%s-%s-cdn", var.application, var.realm, var.environment))
}
