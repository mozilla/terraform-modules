variable "project_id" {
  type = string
}

variable "application" {
  type = string
}

variable "environment" {
  type = string
}

variable "realm" {
  type = string
}

variable "region" {
  type    = string
  default = "us-west1"
}

variable "window_minutes" {
  type    = number
  default = 5
}

variable "model" {
  type    = string
  default = "claude-opus-4-7"
}

variable "labels" {
  type    = map(string)
  default = {}
}
