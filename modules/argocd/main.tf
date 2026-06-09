terraform {
  required_version = ">= 1.5.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Provider is injected by Terragrunt via a generate block in envs/dev/argocd/terragrunt.hcl
# so that the kubeconfig context can reference the cluster name dynamically.

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = var.namespace
  create_namespace = true
  wait             = true
  timeout          = 300

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
}
