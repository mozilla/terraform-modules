/**
 * # Terraform Module: Memcache
 * Creates a memcache instance within GCP using Cloud Memorystore
 */

locals {
  default_name             = "${var.application}-${var.realm}-${var.environment}"
  name                     = coalesce(var.custom_name, local.default_name)
  default_memcache_configs = {} # Add configs that should be added to all memcache instances here
  memcache_configs         = merge(local.default_memcache_configs, var.memcache_configs)
  authorized_network       = var.authorized_network
}

resource "google_project_service" "memcache" {
  project            = var.project_id
  disable_on_destroy = "false"
  service            = "memcache.googleapis.com"
}

resource "google_memcache_instance" "main" {
  project            = var.project_id
  name               = local.name
  authorized_network = local.authorized_network
  region             = var.region
  depends_on         = [google_project_service.memcache]

  node_config {
    cpu_count      = var.cpu_count
    memory_size_mb = var.memory_size_mb
  }
  node_count       = var.node_count
  memcache_version = var.memcache_version

  dynamic "memcache_parameters" {
    for_each = local.memcache_configs
    content {
      params = local.memcache_configs
    }
  }

  maintenance_policy {
    weekly_maintenance_window {
      day      = var.maintenance_window_day
      duration = var.maintenance_duration
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
