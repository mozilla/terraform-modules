output "bigquery" {
  description = "bigquery acls for members associated with the input workgroups"
  value       = local.bigquery_acls
}

output "members" {
  description = "authoritative, fully-qualified list of members associated with the input workgroups"
  value       = toset(lookup(local.access, "members", []))
}

output "google_groups" {
  description = "google groups associated with the input workgroups, unqualified"
  value       = toset(lookup(local.access, "google_groups", []))
}

output "service_accounts" {
  description = "service accounts associated with the input workgroups, unqualified"
  value       = toset(lookup(local.access, "service_accounts", []))
}

output "ids" {
  description = "pass input ids as output"
  value       = var.ids
}
