## Synthetic Monitoring with Cloud Functions

In addition to HTTP uptime checks, you can deploy Cloud Functions as synthetic monitors using the `cloud_function_synthetic_monitor` module. Each function runs monitoring logic (e.g. Puppeteer) and is invoked by a Cloud Monitoring uptime check.

### What This Module Does

- Provisions a Cloud Function (2nd gen) per monitor
- Uploads source code from a zip file
- Injects a secret via environment variable
- Creates a service account per monitor
- Applies IAM bindings for:
  - `roles/secretmanager.secretAccessor`
  - `roles/cloudfunctions.invoker`
- Configures an uptime check for each function