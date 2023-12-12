## Adding New GCP Role to the Module

The other resources grouping of resources are those that fall outside the core resource collection (aka the defaults) and the admin-only resource collection (which is a special case).

For most things, it is assumed that you'll start with the [core resource set](./main.tf) and then add resources as necessary for your target environment.

### TL;DR

- update local list matching your role `folder_additional_roles` or `project_additional_roles` in [variables.tf](./variables.tf)
- add appropriate resource block to [other_roles.tf](./other_roles.tf)

### Adding New Role

You will work with two files in adding a resource: `variables.tf` and `other_roles.tf`.

In [variables.tf](./variables.tf), you want to add your new role to one of the locals->*_additional_roles variable depending on the role type itself (folder or project):

```hcl
locals {
  // This is a list of all the roles that we support in this module
  // IN ADDITION to the roles added via the core rules in main.tf
  // and that already have have existing supporting resource definitions.
  folder_additional_roles = [
    "roles/bigquery.jobUser",
  ]
  project_additional_roles = [
    "roles/automl.editor",
    "roles/cloudtranslate.editor",
    "roles/storage.objectAdmin",
    "roles/translationhub.admin",
    "roles/storage.admin",
    "roles/cloudsql.admin"
  ]
}
```

That's it for that file. We use this list to validate user input.

The other thing to notice here is that three types of input lists are declared - folder, prod, and non_prod. This will allow the module user to set which role but also at which level of permissions. Why? 

This gets a little convoluted as they represent two different things -- folder level roles and project level roles (of two types: prod and non-prod -- or at least those are the two arbitrary types that we use.). However, the roles provided by Google Cloud fall into those same two distinctions: hierarchy where folders contain projects and roles are available at folder or project level. So, in setting them in our environments, we have to understand which are folder level and which are project level. Fortunately, as we define or update our other roles available in [the file](./other_roles.tf), we'll see this explicitly called out.

We see the resource declared here as type `google_folder_iam_binding`, and we create this role by checking if it was in the input list `var.folder_roles`. We also have to use the appropriate folder_id.

```hcl
resource "google_folder_iam_binding" "bq_job_user" {
  count  = contains(var.folder_roles, "roles/bigquery.jobUser") && !var.admin_only ? 1 : 0
  folder = var.google_folder_id
  role   = "roles/bigquery.jobUser"
  members = setunion(
    module.viewers_workgroup.members,
    module.developers_workgroup.members
  )
}
```

Similarly, a project role is of type `google_project_iam_binding`. Additionally, this requires another piece of information - which environment. This then corresponds to which variable list to check it against. In the case below, we see we check the role name against the `var.nonprod_roles` list. Also, we apply it to the variable input named `var.google_nonprod_project_id`

```hcl
resource "google_project_iam_binding" "editor_nonprod" {
  count   = contains(var.nonprod_roles, "roles/editor") && !var.admin_only && var.google_nonprod_project_id != "" ? 1 : 0
  project = var.google_nonprod_project_id
  role    = "roles/editor"
  members = module.developers_workgroup.members
}
```






