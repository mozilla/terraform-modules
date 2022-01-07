/**
 * # Terraform Module for Default AWS Delegated Roles
 * Module that creates roles on accounts to allow delegated access from another account.
 *
 * Primarily used by Web SRE on IT-SE inherited resources.
 *
 * Module will create 4 different roles:
 * - itsre-admin		- Admin role
 * - itsre-readonly	- Readonly role
 * - itsre-poweruser	- Similar to admin but can't do any IAM tasks
 * - itsre-atlantis	- Atlantis (Terraform automation platform) role
 */

locals {
  default_principals = ["arn:aws:iam::${var.external_account_id}:root"]
  all_principals     = setunion(local.default_principals, var.additional_principals)
  terraform_principals = setunion(
    local.all_principals,
    [var.atlantis_principal]
  )
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = local.all_principals
    }
  }
}

resource "aws_iam_role" "admin_role" {
  name                 = "itsre-admin"
  description          = "IT SRE Delegated Admin role"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name      = "itsre-admin"
    Purpose   = "IT SRE delegated role"
    Terraform = "true"
  }
}

resource "aws_iam_role" "readonly_role" {
  name                 = "itsre-readonly"
  description          = "IT SRE Delegated Readonly role"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name      = "itsre-admin"
    Purpose   = "IT SRE delegated role"
    Terraform = "true"
  }
}

resource "aws_iam_role" "poweruser_role" {
  name                 = "itsre-poweruser"
  description          = "IT SRE Delegated PowerUser role"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name      = "itsre-admin"
    Purpose   = "IT SRE delegated role"
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "readonly_attach" {
  role       = aws_iam_role.readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "poweruser_attach" {
  role       = aws_iam_role.poweruser_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

#
# TERRAFORM ROLE SETUP FOR ATLANTIS AUTOMATION
#

data "aws_iam_policy_document" "atlantis_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = local.terraform_principals
    }
  }
}

resource "aws_iam_role" "atlantis_role" {
  name                 = "itsre-atlantis"
  description          = "IT SRE Delegated Atlantis (Terraform Automation) role"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.atlantis_assume_role_policy.json

  tags = {
    Name      = "itsre-atlantis"
    Purpose   = "IT SRE delegated role for Terraform automation"
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "atlantis_attach" {
  role       = aws_iam_role.atlantis_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
