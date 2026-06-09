terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Provider is injected by Terragrunt via a generate block in
# envs/dev/argocd-app/terragrunt.hcl so the kubeconfig context
# can reference the cluster name dynamically.

resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = var.app_name
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.repo_url
        targetRevision = var.target_revision
        path           = var.chart_path
        helm = {
          parameters = [
            { name = "replicaCount",  value = tostring(var.replicas) },
            { name = "image",         value = var.image              },
            { name = "containerPort", value = tostring(var.port)     },
            { name = "service.port",  value = tostring(var.port)     },
          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.app_namespace
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}
