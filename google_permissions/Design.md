## Design

### Three scenarios 

The first two are default settings and the third is the flexible way of adding additional permissions IN ADDITION to the core dev permissions:

- admin_only - one of the use cases found in looking at the existing permissions. admin_only, a single permission setting
- core dev permissions - this is the default and includes settings for folder, project, and then secretmanager access and adder
- adhoc adding of other permissions IN ADDITION to the standard


### Why do the adhoc that way?

We want:

- to control which cloud resources permissions are used by the organization
- a central process to add new cloud resource permissions as necessary
- how with terraform would we keep a developer from getting around this?
    - keep it back in the module
    - exposing the list of desired permissions as strings
    - if that string matches one in our module, then the resource is created (unless admin_only flag is set)


### Why do we want to control which resources are available?

It's less about controlling it and more about gating it. This will ensure that if people need to use a particular type of cloud resource that they take the extra steps of adding it to the shared repository. That includes taking whatever steps are in place for making such a change.
