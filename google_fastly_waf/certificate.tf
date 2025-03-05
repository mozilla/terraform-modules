resource "fastly_tls_subscription" "fastly" {
  domains               = [for domain in var.subscription_domains : domain.name]
  certificate_authority = "lets-encrypt"
}
