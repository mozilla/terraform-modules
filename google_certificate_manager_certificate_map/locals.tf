locals {
  name_prefix = coalesce(var.custom_name_prefix, format("%s-%s-%s", var.application, var.realm, var.environment))

  certificate_domain_map = flatten([
    for cert in var.certificates : [
      for domain in concat([cert.hostname], cert.additional_domains) : {
        certificate = replace(cert.hostname, ".", "-"),
        domain      = domain
      }
    ]
  ])
}
