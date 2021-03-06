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

  memcache_parameters {
    params = local.memcache_configs
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
