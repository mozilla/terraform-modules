module "admins_workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=mozilla_workgroup-1.3.0"
  ids    = var.admin_ids
}

module "developers_workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=mozilla_workgroup-1.3.0"
  ids    = var.developer_ids
}

module "viewers_workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=mozilla_workgroup-1.3.0"
  ids    = var.viewer_ids
}
