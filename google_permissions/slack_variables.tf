variable "feed_id" {
  description = "The ID of the feed to be created"
  type        = string
  default     = "grant_feed"
}

variable "pubsub_topic" {
  description = "The topic where the resource change notifications will be sent"
  type        = string
  default     = "grant_feed_pubsub"
}

variable "function_name" {
  description = "The name of the function to be created"
  type        = string
  default     = "pam-slack-gcf"
}

variable "function_archive_name" {
  description = "The name of the archive file to be created"
  type        = string
  default     = "pam-slack-gcf.zip"
}

variable "slack_webhook_url" {
  description = "The URL of the Slack webhook"
  type        = string
  default     = ""
}

variable "function_region" {
  description = "The region where the function will be deployed"
  type        = string
  default     = "us-central1"
}

variable "slack_project_map" {
  description = "Map of project names to slack channels."
  type        = map(string)
  default     = {}
}