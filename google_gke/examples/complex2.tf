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

  # export metrics to a pre-created BigQuery dataset
  resource_usage_export_dataset_id = "cluster_metrics_dataset"

  # Don't use module-defaults node pool
  # second node pool has special labels for np 2 only;
  # see locals.tf for default values
  node_pools = [
    {
      name = "nodepool-1"
    },
    {
      name         = "nodepool-2"
      machine_type = "n2-standard-2"
      max_count    = 6
    }
  ]

  node_pools_labels = {
    nodepool-2 = {
      "my-np2-label" = "some-value"
    }
  }

  # who can access the k8s control plane
  # adds placeholder bastion network by default
  master_authorized_networks = [
    {
      cidr_block   = "1.2.3.4/32"
      display_name = "bastion"
    }
  ]
}
