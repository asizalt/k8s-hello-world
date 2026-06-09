locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "${get_repo_root()}/modules/argocd"
}

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs = {
    cluster_name = "mock-cluster"
    endpoint     = "https://mock"
    kubeconfig   = "mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

generate "helm_provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "helm" {
  kubernetes {
    config_path    = pathexpand("~/.kube/config")
    config_context = "kind-${local.env.cluster_name}"
  }
}
EOF
}

inputs = {
  argocd_chart_version = local.env.argocd_chart_version
  namespace            = "argocd"
}
