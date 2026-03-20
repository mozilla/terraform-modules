## Adding New GCP Role to the Module

The other resources grouping of resources are those that fall outside the core resource collection (aka the defaults) and the admin-only resource collection (which is a special case).

For most things, it is assumed that you'll start with the [core resource set](./main.tf) and then add resources as necessary for your target environment.

### TL;DR

Add new role to `local.allowed_folder_roles`, `local.allowed_nonprod_roles`, and/or `local.allowed_prod_roles` in [other_roles.tf](./other_roles.tf) depending on the desired scope of the role.

### Implementation details

The other thing to notice here is that three types of input lists are declared - folder, prod, and non_prod. This will allow the module user to set which role but also at which level of permissions. Why?

This gets a little convoluted as they represent two different things -- folder level roles and project level roles (of two types: prod and non-prod -- or at least those are the two arbitrary types that we use.). However, the roles provided by Google Cloud fall into those same two distinctions: hierarchy where folders contain projects and roles are available at folder or project level. So, in setting them in our environments, we have to understand which are folder level and which are project level. Fortunately, as we define or update our other roles available in [the file](./other_roles.tf), we'll see this explicitly called out.
