# GKE
Mozilla IT Service Engineering team module for creating a GKE cluster

This module wraps the upstream terraform registry [GKE module](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/) with some additional niceties

Its worth noting that we are using the beta version of the module to take advantage of the workload identity feature

## Usage:
Sample usage

```hcl
locals {
  project_id   = "mozilla-it-service-engineering"
  name         = "test-cluster"

  node_pools = [
    {
      name               = "default-np-1"
      machine_type       = "e2-small"
      min_count          = "3"
      max_count          = "10"
      max_surge          = "3"
      auto_repair        = true
      auto_upgrade       = true
      initial_node_count = 2

    }
  ]
}

module "gke" {
  source       = "github.com/mozilla-it/terraform-modules//gcp/gke?ref=master"
  costcenter   = "1410"
  environment  = "dev"
  project_id   = local.project_id
  name         = local.name
  region       = var.region
  network      = "default"
  subnetwork   = "default"
  node_pools   = local.node_pools
}
```

There are more options for the `node_pools` input and you these are referenced [here](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine#node_pools-variable)

By default the cluster is configured as a `zonal` cluster, set the `regional` flag to `true` to enable a regional cluster. Read more on regional vs zonal [here](https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters#availability)

## Setting up flux
Optionally you can setup flux on the cluster to start doing gitops by enabling a couple of flags.

```hcl
locals {
  project_id   = "mozilla-it-service-engineering"
  name         = "test-cluster"

  cluster_features = {
    "flux"               = true
    "flux_helm_operator" = true
  }

  flux_settings = {
    "git.url"  = "git@github.com:username/repo"
    "git.path" = "folder"
  }

  node_pools = [
    {
      name               = "default-np-1"
      machine_type       = "e2-small"
      min_count          = "3"
      max_count          = "10"
      max_surge          = "3"
      auto_repair        = true
      auto_upgrade       = true
      initial_node_count = 2

    }
  ]
}

module "gke" {
  source           = "github.com/mozilla-it/terraform-modules//gcp/gke?ref=master"
  costcenter       = "1410"
  environment      = "dev"
  project_id       = local.project_id
  name             = local.name
  region           = var.region
  network          = "default"
  subnetwork       = "default"
  node_pools       = local.node_pools
  cluster_features = local.cluster_features
  flux_settings    = local.flux_settings
}
```
