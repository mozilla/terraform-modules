output "members" {
  description = "authoritative, fully-qualified list of members associated with the input workgroups"
  value       = module.workgroup.members
}

output "google_groups" {
  description = "google groups associated with the input workgroups, unqualified"
  value       = module.workgroup.google_groups
}
