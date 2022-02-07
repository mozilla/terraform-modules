locals {
  name        = "test-redis"
  realm       = "nonprod"
  subnetworks = try(data.terraform_remote_state.vpc.outputs.subnetworks.realm[local.realm][local.project_id], {})
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
  authorized_network = local.subnetworks.regions["us-west1"]["network"]
}