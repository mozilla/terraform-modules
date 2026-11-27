locals {
  # acme_records = { for v in flatten([ for ik, iv in google_certificate_manager_dns_authorization.default : iv.dns_resource_record ]) : v.name => v.data }
  acme_records = { for v in flatten([ for cert in var.certificates : google_certificate_manager_dns_authorization.default[replace(cert.hostname, ".", "-")].dns_resource_record ]) : v.name => v.data }
}

data "dns_cname_record_set" "acme" {
  # for_each = { for k, v in google_certificate_manager_dns_authorization.default : k => v.dns_resource_record}
  for_each = local.acme_records

  host = each.key
}

check "acme" {
  assert {
    condition = alltrue([
      for k, v in data.dns_cname_record_set.acme : v.cname == local.acme_records[k]
    ])
    error_message = <<-EOT
      Some ACME challenge records are missing or incorrect:
      ${join("\n", [
        for k, v in data.dns_cname_record_set.acme : format("CNAME %s %s != %s", v.host, v.cname, local.acme_records[k]) if v.cname != local.acme_records[k]
      ])}
    EOT
  }
}
