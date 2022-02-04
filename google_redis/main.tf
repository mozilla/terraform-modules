/**
 * # Terraform Module: Redis
 * Creates a Redis instance within GCP using Cloud Memorystore
 */

locals {
  default_name = "${var.application}-${var.realm}-${var.environment}"
  name         = coalesce(var.custom_name, local.default_name)
}

resource "google_project_service" "redis" {
  disable_on_destroy = "false"
  service            = "redis.googleapis.com"
}

resource "google_redis_instance" "main" {
  authorized_network = var.authorized_network
  depends_on         = [google_project_service.redis]
  name               = var.name
  memory_size_gb     = var.memory_size_gb
  redis_configs      = var.redis_configs
  redis_version      = var.redis_version
  region             = var.region
  tier               = var.tier

  maintenance_policy {
    description = "Automated weekly maintenance"
    weekly_maintenance_window {
      day = var.maintenance_window_day
      start_time {
        hours = var.maintenance_window_hour
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}