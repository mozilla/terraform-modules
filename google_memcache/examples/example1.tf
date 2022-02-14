locals {
  name        = "test-memcache"
  realm       = "nonprod"
  subnetworks = try(data.terraform_remote_state.vpc.outputs.subnetworks.realm[local.realm][local.project_id], {})
}

module "memcache" {
  source = "github.com/mozilla/terraform-modules//google_memcache?ref=main"

  application        = local.name
  environment        = "dev"
  realm              = local.realm
  memory_size_mb     = 2048
  authorized_network = local.subnetworks.regions["us-west1"]["network"]
}
