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
  replica_name          = coalesce(var.custom_replica_name, "${local.database_name}-replica")
  tier                  = coalesce(var.tier_override, "db-custom-${var.db_cpu}-${var.db_mem_gb * 1024}")
  replica_tier          = coalesce(var.replica_tier_override, "db-custom-${var.replica_db_cpu}-${var.replica_db_mem_gb * 1024}")
  ip_addresses          = google_sql_database_instance.primary.ip_address
  user_labels = merge({
    app_code       = var.application
    component_code = format("%s-%s", var.application, var.component)
    env_code       = var.environment
    realm          = var.realm
  }, var.user_labels)
}

resource "google_sql_database_instance" "primary" {
  provider = google
  name     = local.database_name
  project  = var.project_id
  region   = var.region

  database_version = var.database_version

  settings {
    dynamic "password_validation_policy" {
      for_each = var.password_validation_policy_enable ? range(1) : []
      content {
        enable_password_policy      = true
        min_length                  = var.password_validation_policy_min_length
        complexity                  = var.password_validation_policy_complexity ? "COMPLEXITY_DEFAULT" : null
        reuse_interval              = var.password_validation_policy_reuse_interval
        disallow_username_substring = var.password_validation_policy_disallow_username_substring
        password_change_interval    = var.password_validation_policy_password_change_interval
      }
    }

    availability_type           = var.availability_type
    connector_enforcement       = var.connector_enforcement
    deletion_protection_enabled = var.deletion_protection_enabled
    edition                     = var.edition
    tier                        = local.tier

    backup_configuration {
      enabled                        = var.backup_configuration_enabled
      point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
      location                       = var.backup_configuration_location

      backup_retention_settings {
        retained_backups = 30
        retention_unit   = "COUNT"
      }
    }

    dynamic "data_cache_config" {
      for_each = var.edition == "ENTERPRISE_PLUS" ? [1] : []

      content {
        data_cache_enabled = var.data_cache_enabled
      }
    }

    insights_config {
      query_insights_enabled  = true
      query_plans_per_minute  = var.query_plans_per_minute
      query_string_length     = var.query_string_length
      record_application_tags = true
      record_client_address   = var.psc_enabled ? false : var.record_client_address
    }

    ip_configuration {
      ipv4_enabled                                  = var.enable_public_ip
      ssl_mode                                      = var.ip_configuration_ssl_mode
      enable_private_path_for_google_cloud_services = var.enable_private_path_for_google_cloud_services

      dynamic "psc_config" {
        for_each = var.psc_enabled ? [1] : []

        content {
          allowed_consumer_projects = var.psc_allowed_consumer_projects
          psc_enabled               = var.psc_enabled

          dynamic "psc_auto_connections" {
            for_each = var.psc_auto_connections

            content {
              consumer_network            = psc_auto_connections.value.consumer_network
              consumer_service_project_id = psc_auto_connections.value.consumer_service_project_id
            }
          }
        }
      }

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

    user_labels = local.user_labels

    dynamic "final_backup_config" {
      for_each = var.final_backup_enabled ? [1] : []

      content {
        enabled        = var.final_backup_enabled
        retention_days = var.final_backup_retention_days
      }
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_sql_database_instance" "replica" {
  count                = var.replica_count
  name                 = "${local.replica_name}-${count.index}"
  region               = coalesce(var.replica_region_override, var.region)
  database_version     = var.database_version
  master_instance_name = google_sql_database_instance.primary.name

  settings {
    dynamic "password_validation_policy" {
      for_each = var.password_validation_policy_enable ? range(1) : []
      content {
        enable_password_policy      = true
        min_length                  = var.password_validation_policy_min_length
        complexity                  = var.password_validation_policy_complexity ? "COMPLEXITY_DEFAULT" : null
        reuse_interval              = var.password_validation_policy_reuse_interval
        disallow_username_substring = var.password_validation_policy_disallow_username_substring
        password_change_interval    = var.password_validation_policy_password_change_interval
      }
    }
    availability_type           = var.replica_availability_type
    deletion_protection_enabled = var.deletion_protection_enabled
    edition                     = var.replica_edition
    tier                        = local.replica_tier

    dynamic "data_cache_config" {
      for_each = var.replica_edition == "ENTERPRISE_PLUS" ? [1] : []

      content {
        data_cache_enabled = var.replica_data_cache_enabled
      }
    }

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

    dynamic "insights_config" {
      for_each = var.enable_insights_config_on_replica ? range(1) : []
      content {
        query_insights_enabled  = true
        query_string_length     = 1024
        record_application_tags = true
        record_client_address   = var.psc_enabled ? false : var.record_client_address
      }
    }

    ip_configuration {
      ipv4_enabled                                  = var.enable_public_ip
      private_network                               = var.network
      ssl_mode                                      = var.ip_configuration_ssl_mode
      enable_private_path_for_google_cloud_services = var.enable_private_path_for_google_cloud_services
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          expiration_time = lookup(authorized_networks.value, "expiration_time", null)
          name            = lookup(authorized_networks.value, "name", null)
          value           = lookup(authorized_networks.value, "value", null)
        }
      }
    }

    user_labels = {
      app_code       = var.application
      component_code = format("%s-%s", var.application, var.component)
      env_code       = var.environment
      realm          = var.realm
    }
  }

  deletion_protection = var.deletion_protection
}
