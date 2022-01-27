/**
 * # cloudsql-mysql
 * Creates CloudSQL MySQL Instance.
 */

locals {
  default_database_name = "${var.application}-${var.realm}-${var.environment}-${var.instance_version}"
  database_name         = coalesce(var.custom_database_name, local.default_database_name)
  tier                  = coalesce(var.tier_override, "db-custom-${var.db_cpu}-${var.db_mem_gb * 1024}")

  default_replica_name = "${local.database_name}-failover"
  replica_name         = coalesce(var.custom_replica_name, local.default_replica_name)

  ip_addresses = google_sql_database_instance.master.ip_address

  enable_ha = var.realm == "prod" ? true : false
}

resource "google_sql_database_instance" "master" {
  name             = local.database_name
  region           = var.region
  database_version = var.database_version

  settings {
    tier = local.tier

    availability_type = var.availability_type

    disk_size = var.disk_size
    disk_type = "PD_SSD"
    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      start_time         = "20:00"
      location           = "us"

      backup_retention_settings {
        retained_backups = 30
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled    = var.enable_public_ip
      private_network = var.network
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          expiration_time = lookup(authorized_networks.value, "expiration_time", null)
          name            = lookup(authorized_networks.value, "name", null)
          value           = lookup(authorized_networks.value, "value", null)
        }
      }
    }

    maintenance_window {
      day          = "2"
      hour         = "16"
      update_track = var.realm == "prod" ? "stable" : "canary"
    }

    user_labels = {
      app         = var.application
      environment = var.environment
      realm       = var.realm
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [settings.0.disk_size]
  }
}

resource "google_sql_database_instance" "replica" {
  count                = (local.enable_ha || var.force_ha) && var.availability_type != "REGIONAL" ? 1 : 0
  name                 = local.replica_name
  region               = var.region
  database_version     = var.database_version
  master_instance_name = google_sql_database_instance.master.name

  replica_configuration {
    failover_target = "true"
  }

  settings {
    tier = local.tier
    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
        # which keys might be set in maps assigned here, so it has
        # produced a comprehensive set here. Consider simplifying
        # this after confirming which keys can be set in practice.

        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    ip_configuration {
      ipv4_enabled    = var.enable_public_ip
      private_network = var.network
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          expiration_time = lookup(authorized_networks.value, "expiration_time", null)
          name            = lookup(authorized_networks.value, "name", null)
          value           = lookup(authorized_networks.value, "value", null)
        }
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
