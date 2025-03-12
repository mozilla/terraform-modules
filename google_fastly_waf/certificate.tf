resource "fastly_tls_subscription" "fastly" {
  count                 = length(var.subscription_domains) > 0 ? 1 : 0
  domains               = [for domain in var.subscription_domains : domain.name]
  certificate_authority = "lets-encrypt"
}
