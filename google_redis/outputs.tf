output "current_location_id" {
  value = google_redis_instance.main.current_location_id
}

output "host" {
  value = google_redis_instance.main.host
}

output "port" {
  value = google_redis_instance.main.port
}

output "persistence_iam_identity" {
  value = google_redis_instance.main.persistence_iam_identity
}