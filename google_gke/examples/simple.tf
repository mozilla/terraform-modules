data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    bucket = "my-state-bucket"
    prefix = "projects/my-sharedvpc-project"
  }
}

module "gke" {
  source = "github.com/mozilla/terraform-modules//google_gke?ref=main"

  name       = "my-cluster"
  project_id = "shared-clusters"
  realm      = "nonprod"
  region     = "us-west1"

  master_ipv4_cidr_block      = "1.2.3.4/28"
  network                     = "projects/my-vpc-project/global/networks/my-vpc-network"
  pods_ip_cidr_range_name     = "my-pods-or-cluster-secondary-range-name"
  services_ip_cidr_range_name = "my-services-secondary-range-name"
  subnetwork                  = "projects/my-vpc-project/regions/us-west1/subnetworks/my-subnetwork"

  # don't expect metrics to BQ
  enable_resource_consumption_export = false

  # who can access the k8s control plane
  # adds placeholder bastion network by default
  master_authorized_networks = [
    {
      cidr_block   = "1.2.3.4/32"
      display_name = "bastion"
    }
  ]
}
