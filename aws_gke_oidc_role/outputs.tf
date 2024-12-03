output "role_arn" {
  description = "ARN for the GKE-AWS connector role"
  value       = module.iam_assumable_role_for_oidc.iam_role_name
}
