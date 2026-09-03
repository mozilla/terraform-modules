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
    "cloudasset.googleapis.com",
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
  # Gemini Cloud Assist APIs
  cloud_assist_services = var.cloud_assist ? [
    "geminicloudassist.googleapis.com", # chat + Investigations
    "cloudaicompanion.googleapis.com",
    "designcenter.googleapis.com", # "Required & recommended" APIs
    "appoptimize.googleapis.com",
    "apphub.googleapis.com",
    "apptopology.googleapis.com", # recommended for deeper responses
    "recommender.googleapis.com",
    "cloudresourcemanager.googleapis.com", # lets investigations read the project IAM policy
    "policytroubleshooter.googleapis.com", # lets investigations run IAM Policy Troubleshooter
  ] : []

  all_project_services = setunion(local.default_project_services, var.project_services, local.cloud_assist_services)

  # Roles the console "Grant access" step assigns to the proactive agent identity
  cloud_assist_agent_binding_roles = [
    "roles/iam.supportUser",   # proactive troubleshooting
    "roles/cloudhub.operator", # cost optimization
    "roles/appoptimize.admin", # cost optimization
  ]
  # serviceUsageConsumer is not managed authoritatively as it is occasionally
  # configured explicitly and non-canonically by tenants
  cloud_assist_agent_member_roles = [
    "roles/serviceusage.serviceUsageConsumer", # proactive troubleshooting
  ]

  # https://docs.cloud.google.com/cloud-assist/proactive-agents-setup#agent_identity_roles
  cloud_assist_agent_principal = "principal://agents.global.org-${var.organization_number}.system.id.goog/resources/geminicloudassist/projects/${google_project.project.number}/locations/global/agents/cloud"

  default_data_access_logs = ["iam.googleapis.com", "secretmanager.googleapis.com", "sts.googleapis.com", "privilegedaccessmanager.googleapis.com"]
  data_access_logs_filter  = join("\n", toset([for v in concat(local.default_data_access_logs, var.additional_data_access_logs) : "AND NOT protoPayload.serviceName=\"${v}\""]))
}
