/**
 * # gcp-postgres
 * Creates a PostgreSQL instance within GCP using Cloud SQL
 */

# https://www.terraform.io/docs/providers/google/r/sql_database_instance.html
#
# There is no need for failover replicas for regional PostgreSQL database
# as that is provided by default.
# It is possible to create one or more read replicas for regional PostgreSQL
# database. For that see
# https://github.com/terraform-providers/terraform-provider-google/issues/1773#issuecomment-408556558
# for an example.

locals {
  default_database_name = "${var.application}-${var.realm}-${var.environment}-${var.instance_version}"
  database_name         = coalesce(var.custom_database_name, local.default_database_name)
  tier                  = coalesce(var.tier_override, "db-custom-${var.db_cpu}-${var.db_mem_gb * 1024}")
}

resource "google_sql_database_instance" "primary" {
  provider = google-beta
  name     = local.database_name
  project  = var.project_id
  region   = var.region

  database_version = var.database_version

  settings {
    tier              = local.tier
    availability_type = var.availability_type

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      location                       = "us"

      backup_retention_settings {
        retained_backups = 30
        retention_unit   = "COUNT"
      }
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }

    ip_configuration {
      ipv4_enabled = var.enable_public_ip
      require_ssl  = var.ip_configuration_require_ssl
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
          # which keys might be set in maps assigned here, so it has
          # produced a comprehensive set here. Consider simplifying
          # this after confirming which keys can be set in practice.

          expiration_time = lookup(authorized_networks.value, "expiration_time", null)
          name            = lookup(authorized_networks.value, "name", null)
          value           = lookup(authorized_networks.value, "value", null)
        }
      }
      private_network = var.network
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
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

  lifecycle {
    ignore_changes = [settings.0.backup_configuration.0.point_in_time_recovery_enabled]
  }

  deletion_protection = var.deletion_protection

}

resource "google_sql_database_instance" "replica" {
  count                = var.replica_count
  name                 = "${local.database_name}-replica-${count.index}"
  region               = var.region
  database_version     = var.database_version
  master_instance_name = google_sql_database_instance.primary.name

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

  lifecycle {
    ignore_changes = [settings.0.backup_configuration.0.point_in_time_recovery_enabled]
  }

  deletion_protection = var.deletion_protection

}
