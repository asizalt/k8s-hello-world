locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "${get_repo_root()}/modules/app"
}

inputs = {
  name               = local.env.app_name
  image              = local.env.image
  replicas           = local.env.replicas
  port               = local.env.port
  values_output_path = "${get_repo_root()}/helm/hello-app/values.yaml"
}
