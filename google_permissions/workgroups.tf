module "admins_workgroup" {
  source = "../mozilla_workgroup"
  ids    = var.admin_members
}

module "developers_workgroup" {
  source = "../mozilla_workgroup"
  ids    = var.developer_members
}

module "viewers_workgroup" {
  source = "../mozilla_workgroup"
  ids    = var.viewer_members
}