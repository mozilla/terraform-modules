/**
 * # google_datastream
 * 
 * ## WARNING! This is module only does part of the work. Because setting up postgresql as a source (the only thing I've tested) requires a valid database username and password, and we don't want to store passwords in Terraform, this module will only create a Private Connectivity Connection and a BigQuery Destination profile.
 * ### Prework
 * - Pick a new /29 network for Datastream to use. This is the datastream_subnet under Inputs below. Add the subnet to https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/27920489/GCP+Subnet+Allocations for tracking
 * - Create a CloudSQL Auth Proxy so Datastream can connect to Cloud SQL
 *   - Doing this is outside the scope of these docs (that's convenient!), but see here for an example
 *     - CloudSQL Auth Proxy Deployment: https://github.com/mozilla-it/webservices-infra/blob/main/moztodon/k8s/moztodon/templates/deployment-cloudsqlauthproxy.yaml
 *     - CloudSQL Auth Proxy Service: https://github.com/mozilla-it/webservices-infra/blob/main/moztodon/k8s/moztodon/templates/service-cloudsqlauthproxy.yaml
 *   - **Note the IP Address of the resulting Loadbalancer, you'll need it below**
 * ### After this module runs, you will need to:
 * - [This might be mostly specific to Cloud SQL and Postgresql specifically]
 * - Create a SQL user for Datastream to act as in your source database. Save the password
 * - Create a new Stream (which includes setting up the Source Profile) manually
 *   - Go to the Datastream console for your project: https://console.cloud.google.com/datastream/streams
 *   - Choose CREATE STREAM
 *   - Enter the username, password, IP (this is the IP of the CloudSQL Proxy from above), and database name
 *   - For Postgresql specifically, you'll also be instructed to:
 *     - Enable logical replication on the database
 *     - This involves adding a database flag (which requires a db reboot)
 *   - Create a publication and a replication slot
 *     - In SQL you'll need to create a Publication, create a replication slot, and modify permissions for the datastream replication sql user (the console will provide sample queries to accomplish this)
 */

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
