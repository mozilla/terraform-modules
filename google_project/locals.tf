locals {
  project_name         = "${var.project_name}-${var.realm}"
  display_name         = coalesce(var.display_name, local.project_name)
  project_generated_id = "${format("%.25s", "moz-fx-${local.project_name}")}-${random_id.project.hex}"
  project_id           = coalesce(var.project_id, local.project_generated_id)

  app_code       = coalesce(var.app_code, var.project_name)
  component_code = coalesce(var.component_code, "${local.app_code}-uncat")

  default_project_labels = {
    app            = var.project_name
    app_code       = local.app_code
    component_code = local.component_code
    cost_center    = var.cost_center
    program_code   = var.program_code
    program_name   = var.program_name
    realm          = var.realm
    risk_level     = var.risk_level
  }
  all_project_labels = merge(local.default_project_labels, var.extra_project_labels)

  default_project_services = [
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicehealth.googleapis.com",
    "servicenetworking.googleapis.com",
    "stackdriver.googleapis.com",
    "privilegedaccessmanager.googleapis.com"
  ]
  all_project_services = setunion(local.default_project_services, var.project_services)

  default_data_access_logs = ["iam.googleapis.com", "secretmanager.googleapis.com", "sts.googleapis.com"]
  data_access_logs_filter  = join("\n", toset([for v in concat(local.default_data_access_logs, var.additional_data_access_logs) : "AND NOT protoPayload.serviceName=\"${v}\""]))
}
