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

Versioning is automated based on [Semantic Versioning](https://semver.org/), and PR labels. The `patch` `minor` and `major` labels will trigger the respective version bump. `no-release` will not generate a new tag and will skip most CI steps - **Use no-release at your own risk**. 
If your PR contains [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/), it will label itself appropriately.

Release changelogs are generated based off of the contents of your PR description.
Readmes will be automatically generated, using `.terraform-docs.yml` from the module directory (if it exists).

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

If you want to ensure specific people or teams have to review changes to certain modules, add an entry `CODEOWNERS`.

### Documentation

A `README.md` is required for each module, and CI will automatically regenerate it using the [tf-docs github action](https://github.com/terraform-docs/gh-actions).
To include non-generated content in your README, place it outside the `<!-- BEGIN_TF_DOCS -->` block.

## Using these modules

Some examples on using modules in this repository follow.

**Recommended**: Using the (imaginary) `google_gke-cluster` module based on a specific automatically created git tag:
```terraform
 module "gke" {
  source      = "git@github.com:mozilla/terraform-modules.git//google_gke-cluster?ref=google_gke-cluster_v1.0.1"
}
```

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
