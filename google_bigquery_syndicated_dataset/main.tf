/**
 * # google_bigquery_syndicated_dataset
 *
 * Creates a BigQuery dataset configured for syndication to Mozilla Data Platform
 * infrastructure (mozdata and data-shared projects).  This module is meant to
 * simplify the steps in [Importing Data from OLTP Databases to BigQuery via Federated Queries](https://mozilla-hub.atlassian.net/wiki/spaces/IP/pages/473727279/Importing+Data+from+OLTP+Databases+to+BigQuery+via+Federated+Queries)
 *
 * This module abstracts away the syndication boilerplate:
 * - Resolves syndication service accounts via workgroup
 * - Looks up the org custom role for syndication
 * - Auto-discovers whether syndicated datasets exist in data platform projects
 * - Adds dataset authorizations only when targets exist
 *
 * ## Target Inference
 *
 * The `syndicated_dataset_id` (defaults to `dataset_id`) determines targets:
 * - Does NOT end in `_syndicate` → user-facing → both mozdata and data-shared
 * - Ends in `_syndicate` → data-shared only
 * - Eventually the syndication datasets themselves will be inferred from bqetl metadata available to all MozCloud tenant infrastructure
 *
 * ## State propagation
 *
 * While this module reduces the amount of PRs required to set up syndication, it will not automatically
 * propagate those changes. You still need to follow the steps on
 * https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/27924945/Atlantis+-+Terraform+Automation#Invoking-Atlantis-without-terraform-changes
 * in order to authorize datasets on the tenant infra side. Eventually policy-as-code and drift
 * detection automation will make these manual steps unnecessary.
 *
 */

locals {
  target_realm          = coalesce(var.target_realm, var.realm)
  syndicated_dataset_id = coalesce(var.syndicated_dataset_id, var.dataset_id)
  is_user_facing        = !endswith(local.syndicated_dataset_id, "_syndicate")

  target_env = local.target_realm == "prod" ? "prod" : "stage"

  # Syndication target configuration: data-shared always, mozdata only for user-facing datasets
  target_config = merge(
    {
      data-shared = {
        project_ids = { prod = "moz-fx-data-shared-prod", nonprod = "moz-fx-data-shar-nonprod-efed" }
        state_path  = "bigquery-new"
      }
    },
    local.is_user_facing ? {
      mozdata = {
        project_ids = { prod = "mozdata", nonprod = "mozdata-nonprod" }
        state_path  = "bigquery"
      }
    } : {}
  )

  targets = {
    for name, cfg in local.target_config :
    name => {
      project_id   = cfg.project_ids[local.target_realm]
      state_prefix = "projects/${name}/${local.target_realm}/envs/${local.target_env}/${cfg.state_path}"
    }
  }
}

# Remote state from syndication targets to check if datasets exist
data "terraform_remote_state" "syndication_target" {
  for_each = local.targets

  backend = "gcs"

  config = {
    bucket = "${each.value.project_id}-tf"
    prefix = each.value.state_prefix
  }
}

locals {
  # Authorized dataset access for targets where the syndicated dataset exists
  syndication_dataset_access = [
    for name, target in local.targets : {
      project_id = target.project_id
      dataset_id = local.syndicated_dataset_id
    }
    if contains(
      values(data.terraform_remote_state.syndication_target[name].outputs.syndicate_datasets),
      local.syndicated_dataset_id
    )
  ]
}

data "terraform_remote_state" "org" {
  backend = "gcs"

  config = {
    bucket = "moz-fx-platform-mgmt-global-tf"
    prefix = "projects/org"
  }
}

# Service accounts that perform syndication
# Currently Jenkins with plans to move to Airflow, see https://mozilla-hub.atlassian.net/browse/SVCSE-3005
module "syndication_workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=main"
  ids    = var.syndication_workgroup_ids
  # TODO this config will need to be removed when SVCSE-4008 is complete
  terraform_remote_state_bucket = "moz-fx-data-terraform-state-global"
  terraform_remote_state_prefix = "projects/data-shared/global/access-groups"
}

resource "google_bigquery_dataset" "dataset" {
  count = var.create_dataset ? 1 : 0

  dataset_id                      = var.dataset_id
  location                        = var.location
  friendly_name                   = var.friendly_name
  description                     = var.description
  labels                          = var.labels
  default_table_expiration_ms     = var.default_table_expiration_ms
  default_partition_expiration_ms = var.default_partition_expiration_ms
  max_time_travel_hours           = var.max_time_travel_hours
  delete_contents_on_destroy      = var.delete_contents_on_destroy

  # projectOwners access is implied unless explicitly disabled
  dynamic "access" {
    for_each = var.disable_project_owners_access ? [] : [1]
    content {
      role          = "OWNER"
      special_group = "projectOwners"
    }
  }

  # App-specific IAM access
  dynamic "access" {
    for_each = [for a in var.access : a if a.role != null && a.dataset == null && a.view == null]
    content {
      role           = access.value.role
      user_by_email  = access.value.user_by_email
      group_by_email = access.value.group_by_email
      special_group  = access.value.special_group
      domain         = access.value.domain
      iam_member     = access.value.iam_member
    }
  }

  # App-specific non-syndicate authorized dataset access
  dynamic "access" {
    for_each = [for a in var.access : a if a.dataset != null]
    content {
      dataset {
        dataset {
          project_id = access.value.dataset.dataset.project_id
          dataset_id = access.value.dataset.dataset.dataset_id
        }
        target_types = access.value.dataset.target_types
      }
    }
  }

  # App-specific authorized views
  dynamic "access" {
    for_each = [for a in var.access : a if a.view != null]
    content {
      view {
        project_id = access.value.view.project_id
        dataset_id = access.value.view.dataset_id
        table_id   = access.value.view.table_id
      }
    }
  }

  # Syndication service account access
  dynamic "access" {
    for_each = module.syndication_workgroup.service_accounts
    content {
      role          = data.terraform_remote_state.org.outputs.bigquery_jobs_manage_syndicate_dataset_role_id
      user_by_email = access.value
    }
  }

  # Syndication authorized dataset access for syndicates
  dynamic "access" {
    for_each = local.syndication_dataset_access
    content {
      dataset {
        dataset {
          project_id = access.value.project_id
          dataset_id = access.value.dataset_id
        }
        target_types = ["VIEWS"]
      }
    }
  }
}

# Non-authoritative syndication access for externally-managed datasets
resource "google_bigquery_dataset_access" "syndication_role" {
  for_each = var.create_dataset ? {} : {
    for sa in module.syndication_workgroup.service_accounts : sa => sa
  }

  dataset_id    = var.dataset_id
  role          = data.terraform_remote_state.org.outputs.bigquery_jobs_manage_syndicate_dataset_role_id
  user_by_email = each.value
}

resource "google_bigquery_dataset_access" "syndicated_authorization" {
  for_each = var.create_dataset ? {} : {
    for entry in local.syndication_dataset_access : "${entry.project_id}/${entry.dataset_id}" => entry
  }

  dataset_id = var.dataset_id

  dataset {
    dataset {
      project_id = each.value.project_id
      dataset_id = each.value.dataset_id
    }
    target_types = ["VIEWS"]
  }
}
