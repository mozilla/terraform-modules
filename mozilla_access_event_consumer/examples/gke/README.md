# Kubernetes Example

This example shows how to consume access event notifications from Kubernetes. The example uses a CronJob for batch processing, but you can adapt it to use any Kubernetes workload type (Deployment, Job, etc.).

## Prerequisites

- Your application must be deployed on GKE
- You must deploy this from an infrastructure repo (e.g., `dataservices-infra`, `webservices-infra`)
- The infrastructure repo should provide a tenant module with `gke_service_account_email` output
- In complex scenarios where multiple workload identities are configured in GKE, those other service accounts can be used instead

## Usage in Your Infrastructure Repo

### 1. Add Module to Terraform

Copy the terraform code here to your tenant infrastructure e.g. `webservices-infra/TENANT/tf/ENV`

### 2. Build and Push Container Image

Use your standard container image tooling to push images to GCR. Customize the
code and copy it to your application repo.

See https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/1676935173/Standards+Container+Images and https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/1923448980/CI+with+GitHub+Actions+GA.

Edit `app/main.py` and implement your application-specific logic in the `process_access_event()` function.

### 3. Deploy to Kubernetes

See the [k8s/](./k8s/myapp/) directory for an example Helm chart that deploys a CronJob. You may need to set additional values in your `values.yaml` files.

## Configuration

### Environment Variables

- `PROJECT_ID` - GCP project ID
- `SUBSCRIPTION_ID` - Pub/Sub subscription ID (from Terraform output)
- `LOG_LEVEL` - Logging level (INFO, DEBUG, ERROR)
- `MAX_MESSAGES` - Maximum messages to pull per run (default: 100)
- `ACK_DEADLINE_SECONDS` - Message acknowledgment deadline (default: 60)

### Secrets

The example helm chart integrates with Google Secret Manager, see https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/27919985/GKE+Cluster+Secrets+Management.
