# Mozilla SRE Terraform Modules

These are Terraform modules used across Mozilla SRE teams and related infrastructure partners.

These modules are intended for Mozilla usage internally. They are not built or supported with external users' usage in mind.

## Automation

### Pre-commit Checks
This repository uses [pre-commit](https://pre-commit.com/) for running some pre-git-commit checks. Install pre-commit locally (see link for instructions) for your own workspace to also run these checks on every git commit. Pipenv files are included optionally if you use such tooling for managing your pre-commit (or other Python packages) installation.

This repository also uses [GitHub Actions](.github/workflows/ci.yaml) to run stateless (e.g. no Terraform state or provider connections required) automated checks, including the following:
* terraform fmt --recursive & terraform validate for each module directory;
* for each module (top level subdirectory):
  * the module subdirectory name follows the format `provider_name`;
  * a `README.md` exists (use terraform-docs, detailed below, to generate);
  * a `main.tf` file exists;
  * a `versions.tf` file exists & contains value `terraform.required_version`;
* security checks are run, including validating providers used are allowed & secrets scanning (via same pre-commit tooling).

### Versioning and Releases

Versioning is automated based on [Semantic Versioning](https://semver.org/) using [`semantic-release`](https://github.com/semantic-release/semantic-release).
Release changelogs are automated by enforcing [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
as a PR check using [`semantic-pull-request`](https://github.com/marketplace/actions/semantic-pull-request).

Conventional commit convention will be checked on:
* commit message for **PRs with a single commit**
* PR title for **PRs with multiple commits**

Additionally, commit squashing is required before merging for PRs with multiple commits.

#### Valid PR titles examples:

- `fix: GKE bastion host default notes.`
- `feat: Copy google-cdn-external from cloudops-infra.`
- `refactor!: Drop support for Terraform 0.12.`
- `feat(google_cloudsql_mysql): Add query insights settings.`

Note that since PR titles only have a single line, you have to use the ! syntax for breaking changes.


## Creating modules

Each module should follow the given structure within the top level of this directory:

```
├── aws_asg-lifecycle  # 1 top-level directory per module, named provider_name
│   ├── README.md  # required, generated via terraform-docs
│   ├── main.tf  # required
│   ├── outputs.tf
│   ├── variables.tf
│   └── versions.tf  # required, validated to contain terraform.required_version
```

### Naming

The name should follow the format `provider_module-name` like `google_gke-cluster` or `newrelic_synthetic-checks`. The providers should follow the names listed here (this is to support future work on publishing our Terraform modules): https://registry.terraform.io/browse/providers

### Ownership

By default, anyone who is an owner or contributor on this repository can review, approve & merge PRs on any module.

If you want to ensure specific people or teams have to review changes to certain modules, put a `CODEOWNERS` file in your module's subdirectory.

### Documentation

A `README.md` is required for each module, however its contents are not currently validated. It is strongly recommended that you at least start your `README.md` using [terraform-docs](https://github.com/terraform-docs/terraform-docs).

If you need to generate documentation run:

```
for directory in */
do
  terraform-docs --sort-by required markdown "$directory" > "${directory}README.md"
done
```

Alternatively, `pre-commit install` on this repository to automatically format the docs on commit.

## Using these modules

Some examples on using modules in this repository follow.

Using the (imaginary) `google_gke-cluster` module with always the latest version (e.g. following main branch):

```terraform
 module "gke" {
  source      = "git@github.com:mozilla/terraform-modules.git//google_gke-cluster?ref=main"
}
```

Using the (imaginary) `google_gke-cluster` module based on a specific (imaginary) git commit:
```terraform
 module "gke" {
  source      = "git@github.com:mozilla/terraform-modules.git//google_gke-cluster?ref=69ad17030bfa4ea46f68f8cc449102d446658851"
}
```

Using the (imaginary) `google_gke-cluster` module based on a specific (imaginary) git tag:
```terraform
 module "gke" {
  source      = "git@github.com:mozilla/terraform-modules.git//google_gke-cluster?ref=google_gke-cluster_v1.0.1"
}
```
