variable "name" {
  description = "Name of Terraform state bucket (recommended to use GCP Project or Service ID)."
  type        = string
}

variable "tfadmin_project_id" {
  description = "GCP Project ID of GCP Project that owns/administers the state bucket."
  type        = string
}
