module "admins_workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=main"
  ids    = var.admin_ids
}

module "developers_workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=main"
  ids    = var.developer_ids
}

module "viewers_workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=main"
  ids    = var.viewer_ids
}
