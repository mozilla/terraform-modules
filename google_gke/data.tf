data "google_project" "project" {
}

data "google_compute_zones" "available" {
  region  = var.region
  project = var.project_id
}

data "google_compute_network" "vpc" {
  name    = var.network
  project = var.project_id
}

data "google_client_config" "default" {
}

data "google_container_cluster" "cluster" {
  name     = module.gke.name
  project  = var.project_id
  location = module.gke.location
}
