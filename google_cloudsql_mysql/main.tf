/**
 * # cloudsql-mysql
 * Creates CloudSQL MySQL Instance.
 */

locals {
  default_database_name = "${var.application}-${var.realm}-${var.environment}-${var.instance_version}"
  database_name         = coalesce(var.custom_database_name, local.default_database_name)
  tier                  = coalesce(var.tier_override, "db-custom-${var.db_cpu}-${var.db_mem_gb * 1024}")

  default_replica_name = "${local.database_name}-replica"
  replica_name         = coalesce(var.custom_replica_name, local.default_replica_name)

  ip_addresses = google_sql_database_instance.primary.ip_address

  enable_ha = var.realm == "prod" ? true : false
}

resource "google_sql_database_instance" "primary" {
  name             = local.database_name
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  settings {
    tier = local.tier

    availability_type = var.availability_type

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
      require_ssl     = var.ip_configuration_require_ssl
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
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    user_labels = {
      app         = var.application
      environment = var.environment
      realm       = var.realm
    }
  }

  deletion_protection = var.deletion_protection

}

resource "google_sql_database_instance" "replica" {
  count                = var.replica_count
  name                 = "${local.replica_name}-${count.index}"
  project              = var.project_id
  region               = var.region
  database_version     = var.database_version
  master_instance_name = google_sql_database_instance.primary.name

  replica_configuration {
    failover_target = "false"
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
      require_ssl     = var.ip_configuration_require_ssl
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

  deletion_protection = var.deletion_protection

}
