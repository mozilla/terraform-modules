# Cloud Function Example

This example deploys a Cloud Function that processes employee access event notifications.

## Prerequisites

The following APIs must be enabled in your project:

- `cloudbuild.googleapis.com`
- `cloudfunctions.googleapis.com`
- `run.googleapis.com`

These should be specified in e.g. `webservices-infra/projects/tf/global/locals.tf` for your projects.

## Usage

1. Customize the function code in `src/main.py`:
   - Implement your application-specific access event logic
   - Add any dependencies to `requirements.txt`
2. Copy the terraform code here to your tenant infrastructure e.g. `webservices-infra/TENANT/tf/ENV`
3. Update the secrets setup in `main.tf` (or remove it)
4. File a PR and plan/apply normally

## Testing

Test your function locally before deploying:

```bash
cd src
pip install -r requirements.txt
python main.py
```

This runs the function with test data in dry-run mode.
