data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    bucket = "my-state-bucket"
    prefix = "projects/my-sharedvpc-project"
  }
}

module "gke" {
  source = "github.com/mozilla/terraform-modules//google_gke?ref=main"

  name               = "my-cluster"
  project_id         = "shared-clusters"
  realm              = "nonprod"
  region             = "us-west1"
  shared_vpc_outputs = data.terraform_remote_state.projects.outputs.projects.shared.nonprod.id["shared-clusters"].regions["us-west1"]

  # export metrics to a module-created BigQuery dataset
  create_resource_usage_export_dataset = true

  # access docker image GARs in another project
  # (self-same cluster project id included by default)
  registry_project_ids = [
    "team-app1"
  ]

  # who can access the k8s control plane
  # adds placeholder bastion network by default
  master_authorized_networks = [
    {
      cidr_block   = "1.2.3.4/32"
      display_name = "bastion"
    }
  ]
}

