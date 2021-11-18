# Mozilla SRE Terraform Modules

These are Terraform modules used across Mozilla SRE teams and related infrastructure partners.

These modules are intended for Mozilla usage internally. They are not built or supported with external users' usage in mind.

## Automation

This repository uses [pre-commit](https://pre-commit.com/) for running some pre-git-commit checks. Install pre-commit locally (see link for instructions) for your own workspace to also run these checks on every git commit. Pipenv files are included optionally if you use such tooling for managing your pre-commit (or other Python packages) installation.

This repository also uses [GitHub Actions](.github/workflows/ci.yaml) to run stateless (e.g. no Terraform state or provider connections required) automated checks, including the following:
* terraform fmt --recursive & terraform validate for each module directory;
* for each module (top level subdirectory):
  * the module subdirectory name follows the format `provider_name`;
  * a `README.md` exists (use terraform-docs, detailed below, to generate);
  * a `main.tf` file exists;
  * a `versions.tf` file exists & contains value `terraform.required_version`;
* security checks are run, including validating providers used are allowed & secrets scanning (via same pre-commit tooling).

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
  terraform-docs --sort-by-required markdown "$directory" > "${directory}README.md"
done
```

Alternatively, `pre-commit install` on this repository to automatically format the docs on commit.

### Versioning

Currently, for Mozilla SRE Terraform modules versioning, we simply use git commits or git tags, using a `module-name_tag-version` structure, and the GitHub repository for the Terraform GitHub source. So:

1. Person pushes Terraform modules changes to mozilla/terraform-modules;
2. Person optionally tags their mozilla/terraform-modules module git commit following structure `module-name_tag-version`;
3. Person who always wants to work on the latest version of that module pins to main (softly not recommended);
4. Person who wants to stay on a pinned “version” of that module pins to a git commit or git tag (see usage instructions below).

This does not give us version filtering, nor a clear mapping of Terraform modules source code to versions - however, we do have some backlog tickets to address fully-featured Terraform modules versioning & publication in future sprints.

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
