output "dataset_id" {
  description = "The dataset ID."
  value       = var.dataset_id
}

output "id" {
  description = "The fully-qualified dataset ID (projects/PROJECT/datasets/DATASET)."
  value       = var.create_dataset ? google_bigquery_dataset.dataset[0].id : null
}

output "self_link" {
  description = "The URI of the created resource."
  value       = var.create_dataset ? google_bigquery_dataset.dataset[0].self_link : null
}

output "syndication_role_id" {
  description = "The custom role ID used for syndication access."
  value       = data.terraform_remote_state.org.outputs.bigquery_jobs_manage_syndicate_dataset_role_id
}

output "syndication_service_accounts" {
  description = "The service account emails used for syndication."
  # https://mozilla-hub.atlassian.net/browse/SVCSE-3005 - migrating from
  # Jenkins to Airflow for syndication.
  value = module.syndication_workgroup.service_accounts
}

output "syndication_targets_active" {
  description = "Map of syndication target names to whether authorized dataset access is active."
  value = {
    for name, target in local.targets :
    name => contains(
      values(data.terraform_remote_state.syndication_target[name].outputs.syndicate_datasets),
      local.syndicated_dataset_id
    )
  }
}
