#locals {
#connection_profile_name = "projects/${var.project_id}/locations/${var.location}/connectionProfiles/${var.source_connection_profile_name}"
#}

resource "google_datastream_private_connection" "default" {
  display_name          = "Datastream private connection profile for ${var.application}-${var.realm}-${var.environment}"
  location              = var.location
  private_connection_id = "datastream-private-conn-${var.environment}-${var.location}"

  labels = {
    app_code       = var.application
    component_code = format("%s-%s", var.application, var.component)
    env_code       = var.environment
    realm          = var.realm
  }

  vpc_peering_config {
    vpc    = var.vpc_network
    subnet = var.datastream_subnet
  }
}

#resource "google_datastream_connection_profile" "source_connection_profile" {
#  display_name          = "Datastream private connection profile for ${var.application}-${var.realm}-${var.environment}"
#  location              = var.location
#  connection_profile_id = "datastream-conn-${var.environment}-${var.location}"
#
#  dynamic "postgresql_profile" {
#    for_each = { for profile in var.postgresql_profile : "${profile.hostname}.${profile.username}.${profile.database}" => profile }
#    content {
#      hostname = postgresql_profile.value.hostname
#      username = postgresql_profile.value.username
#      database = postgresql_profile.value.database
#      password = "thisisnotarealpassword"
#    }
#  }
#
#  private_connectivity {
#    private_connection = google_datastream_private_connection.default.id
#  }
#}

resource "google_datastream_connection_profile" "destination_connection_profile" {
  display_name          = "Datastream BQ connection profile for ${var.project_id}-${var.environment}-${var.location}"
  location              = var.location
  connection_profile_id = "destination-profile"

  bigquery_profile {}
}

#resource "google_datastream_stream" "default" {
#  stream_id    = "datastream-${var.project_id}-${var.environment}-${var.location}"
#  location     = var.location
#  display_name = "Datastream for ${var.project_id}-${var.environment}-${var.location}"
#  source_config {
#    source_connection_profile = google_datastream_connection_profile.source_connection_profile.id
#    mysql_source_config {}
#  }
#  destination_config {
#    destination_connection_profile = google_datastream_connection_profile.destination_connection_profile.id
#    bigquery_destination_config {
#      source_hierarchy_datasets {
#        dataset_template {
#          location = var.location
#        }
#      }
#    }
#  }
#
#  backfill_all {
#  }
#}
