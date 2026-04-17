# ddos_detection

Deploys the Fastly WAF DDoS detection analyst on Cloud Run. Every 5 minutes, Cloud Scheduler triggers a Cloud Run Job that queries BigQuery for anomalous traffic patterns and sends the results to an LLM for analysis.

## High level architecture

```
 ┌───────────────────────────────────────────────────────────────────────────┐
 │  GCP Project                                                              │
 │                                                                           │
 │   ┌────────────────────┐                                                  │
 │   │  Cloud Scheduler   │  1. every 5 min                                  │
 │   │  SA: ddos-sch      │──────────────────┐                               │
 │   └────────────────────┘  HTTP POST :run  │                               │
 │                                           ▼                               │
 │   ┌────────────────────┐        ┌──────────────────────┐                  │
 │   │ Artifact Registry  │2.image │   Cloud Run Job      │ 5. call API      │
 │   │ ddos-detection     │◄───────│   analyst.py         │──────────────────┼───┐
 │   └────────────────────┘        │   SA: ddos-run       │                  │   │
 │                                 └────┬──────┬──────┬───┘                  │   │
 │                                      │      │      │                      │   │
 │           3. read API key            │      │      │ 6. write report      │   │
 │   ┌────────────────────┐◄────────────┘      │      └────►┌──────────────┐ │   │
 │   │  Secret Manager    │                    │            │  GCS Bucket  │ │   │
 │   │  llm-api-key       │           4. query │            │  reports/    │ │   │
 │   └────────────────────┘                    ▼            └──────────────┘ │   │
 │                                 ┌──────────────────────┐                  │   │
 │                                 │  BigQuery            │                  │   │
 │                                 │  fastly_cdn_logs     │                  │   │
 │                                 └──────────────────────┘                  │   │
 └───────────────────────────────────────────────────────────────────────────┘   │
                                                                                 ▼
                                                                  ┌──────────────────────┐
                                                                  │  LLM API             │
                                                                  └──────────────────────┘
```

## Resources created

| Resource | Description |
|---|---|
| `google_artifact_registry_repository` | Docker registry for the analyst image |
| `google_service_account` (x2) | Runner SA (BQ + Secret + GCS access) and Scheduler SA (job invoker) |
| `google_secret_manager_secret` | Stores the LLM API key (value set manually post-apply) |
| `google_storage_bucket` | Stores detection reports as text files; objects expire after 90 days |
| `google_cloud_run_v2_job` | Runs `analyst.py` on each trigger |
| `google_cloud_scheduler_job` | Fires every 5 minutes via HTTP POST to the Cloud Run Jobs API |

## Usage

```hcl
module "ddos_detection" {
  source = "../modules/ddos_detection"

  project_id  = local.project_id
  application = local.application
  environment = local.environment
  realm       = local.realm
  labels      = local.labels
}
```

## Variables

| Name | Type | Default | Description |
|---|---|---|---|
| `project_id` | `string` | — | GCP project ID |
| `application` | `string` | — | Application name (e.g. `sumo`) |
| `environment` | `string` | — | Environment name (e.g. `stage`) |
| `realm` | `string` | — | Realm (e.g. `nonprod`) |
| `region` | `string` | `us-west1` | GCP region |
| `window_minutes` | `number` | `5` | Detection window in minutes |
| `model` | `string` | `claude-opus-4-7` | LLM model ID |
| `labels` | `map(string)` | `{}` | Labels applied to all resources |

The BigQuery dataset is derived automatically as `{application}_{realm}_{environment}_fastly_cdn_logs`, table `fastly`. This matches the naming convention used by the `google_fastly_waf` Terraform module.

## Outputs

| Name | Description |
|---|---|
| `job_name` | Cloud Run Job name |
| `registry_url` | Artifact Registry base URL for pushing images |
| `llm_secret_id` | Secret Manager secret ID for the LLM API key |
| `results_bucket` | GCS bucket name where detection reports are written |

## Post-apply steps

### 1. Set the LLM API key

The secret is created by Terraform but its value must be set manually:

```bash
echo -n "sk-ant-..." | gcloud secrets versions add \
  $(terraform output -raw llm_secret_id) \
  --data-file=- \
  --project=<project_id>
```

### 2. Build and push the analyst image

```bash
REGISTRY=$(terraform output -raw registry_url)

docker build -t ${REGISTRY}/analyst:latest /path/to/ddos_detection
docker push ${REGISTRY}/analyst:latest
```

The Cloud Run Job pulls `analyst:latest` on each execution. Redeploy by pushing a new image — no Terraform changes needed.

## Report output

Reports are written to GCS at:

```
gs://<project_id>-ddos-detection/reports/YYYY-MM-DD/HH-MM_<scenario>.txt
```

Scenarios: `new`, `ongoing-{id}-w{n}`, `ended-{id}`. Objects are automatically deleted after 90 days.

To browse reports:

```bash
gsutil ls gs://$(terraform output -raw results_bucket)/reports/
```
