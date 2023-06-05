/**
 * # Terraform Module: Redis
 * Creates a Redis instance within GCP using Cloud Memorystore
 */

locals {
  default_name          = "${var.application}-${var.realm}-${var.environment}"
  name                  = coalesce(var.custom_name, local.default_name)
  default_redis_configs = { activedefrag : "yes" }
  redis_configs         = merge(local.default_redis_configs, var.redis_configs)
}

resource "google_project_service" "redis" {
  project            = var.project_id
  disable_on_destroy = "false"
  service            = "redis.googleapis.com"
}

resource "google_redis_instance" "main" {
  project                 = var.project_id
  authorized_network      = var.authorized_network
  depends_on              = [google_project_service.redis]
  name                    = local.name
  memory_size_gb          = var.memory_size_gb
  redis_configs           = local.redis_configs
  redis_version           = var.redis_version
  region                  = var.region
  tier                    = var.tier
  transit_encryption_mode = var.transit_encryption_mode
  auth_enabled            = var.auth_enabled
  connect_mode            = "PRIVATE_SERVICE_ACCESS" # Used for shared VPC access https://cloud.google.com/memorystore/docs/redis/networking

  dynamic "persistence_config" {
    for_each = var.enable_persistence ? [1] : []
    content {
      persistence_mode    = "RDB"
      rdb_snapshot_period = "ONE_HOUR"
    }
  }

  maintenance_policy {
    weekly_maintenance_window {
      day = var.maintenance_window_day
      start_time {
        hours   = var.maintenance_window_hour
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }
  }

  labels = {
    app_code       = var.application
    component_code = format("%s-%s", var.application, var.component)
    env_code       = var.environment
    realm          = var.realm
  }

  lifecycle {
    prevent_destroy = true
  }
}
