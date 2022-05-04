variable "repository_id" {
  type    = string
  default = null
}

variable "format" {
  type    = string
  default = "DOCKER"
}

variable "location" {
  type        = string
  default     = "us"
  description = "Location of the repository. Should generally be set to a multi-region location like 'us' or 'europe'."
}

variable "description" {
  type    = string
  default = null
}

variable "application" {
  type        = string
  description = "Application, e.g. bouncer."
}

variable "realm" {
  description = "Realm, e.g. nonprod."
  type        = string
}

variable "project" {
  type    = string
  default = null
}

variable "repository_readers" {
  type        = list(string)
  default     = []
  description = "List of principals that should be granted read access to the respository."
}

variable "writer_service_account_id" {
  type    = string
  default = "artifact-writer"
}
