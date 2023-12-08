module "admins_workgroup" {
  source = "../mozilla_workgroup"
  ids    = var.admin_ids
}

module "developers_workgroup" {
  source = "../mozilla_workgroup"
  ids    = var.developer_ids
}

module "viewers_workgroup" {
  source = "../mozilla_workgroup"
  ids    = var.viewer_ids
}