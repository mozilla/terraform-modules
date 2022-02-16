locals {
  name     = "test-memcache"
  realm    = "nonprod"
  networks = try(data.terraform_remote_state.vpc.outputs.networks.realm[local.realm], {})
}

module "memcache" {
  source = "github.com/mozilla/terraform-modules//google_memcache?ref=main"

  application        = local.name
  environment        = "dev"
  realm              = local.realm
  memory_size_mb     = 2048
  authorized_network = local.networks.id
}
