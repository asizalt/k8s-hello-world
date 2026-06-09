variable "argocd_chart_version" {
  description = "Helm chart version for argo-cd"
  type        = string
  default     = "7.3.4"
}

variable "namespace" {
  description = "Namespace to install ArgoCD into"
  type        = string
  default     = "argocd"
}
