variable "environment" {
  type        = string
  description = "Application environment"
}

variable "realm" {
  description = "Realm e.g., nonprod."
  type        = string
}

variable "project" {
  type        = string
  description = "GCP project ID"
}

variable "log_filter" {
  type        = string
  description = "Log filter string, because presumably you don't want everything? Maybe you do? Example: 'resource.type=\"http_load_balancer\" resource.labels.target_proxy_name=\"productdelivery-prod-cdn\"'"
}
