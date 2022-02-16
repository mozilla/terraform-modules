locals {
  name     = "test-redis"
  realm    = "nonprod"
  networks = try(data.terraform_remote_state.vpc.outputs.networks.realm[local.realm], {})
}

module "redis" {
  source = "github.com/mozilla/terraform-modules//google_redis?ref=main"

  application    = local.name
  environment    = "dev"
  realm          = local.realm
  memory_size_gb = 2
  redis_configs = {
    maxmemory-policy = "allkeys-lru"
  }
  tier               = "STANDARD_HA"
  authorized_network = local.networks.id
}
