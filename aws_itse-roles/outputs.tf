output "admin_role_arn" {
  description = "ARN for the IT-SE Delegated Access Admin Role"
  value       = aws_iam_role.admin_role.arn
}

output "readonly_role_arn" {
  description = "ARN for the IT-SE Delegated Access Admin Role"
  value       = aws_iam_role.readonly_role.arn
}

output "poweruser_role_arn" {
  description = "ARN for the IT-SE Delegated Access Admin Role"
  value       = aws_iam_role.poweruser_role.arn
}

output "atlantis_role_arn" {
  description = "ARN for the IT-SE Delegated Access Admin Role"
  value       = aws_iam_role.atlantis_role.arn
}
