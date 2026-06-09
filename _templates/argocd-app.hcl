locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "${get_repo_root()}/modules/argocd-app"
}

dependency "cluster" {
  config_path = "../cluster"
}

dependency "argocd" {
  config_path = "../argocd"
}

generate "kubernetes_provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = "kind-${dependency.cluster.outputs.cluster_name}"
}
EOF
}

inputs = {
  app_name        = "hello-app"
  repo_url        = local.env.repo_url
  target_revision = local.env.target_revision
  chart_path      = local.env.chart_path
  app_namespace   = local.env.app_namespace
  image           = local.env.image
  replicas        = local.env.replicas
  port            = local.env.port
}
