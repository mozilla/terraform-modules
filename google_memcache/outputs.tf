output "memcache_nodes" {
  value = google_memcache_instance.main.memcache_nodes
}

output "discovery_endpoint" {
  value = google_memcache_instance.main.discovery_endpoint
}
