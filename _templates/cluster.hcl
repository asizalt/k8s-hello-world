locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "${get_repo_root()}/modules/kind-cluster"
}

inputs = {
  name         = local.env.cluster_name
  k8s_version  = local.env.k8s_version
  worker_count = local.env.worker_count
}
