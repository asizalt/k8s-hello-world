variable "app_name" {
  description = "Name of the ArgoCD Application"
  type        = string
}

variable "repo_url" {
  description = "Git repository URL ArgoCD will watch"
  type        = string
}

variable "target_revision" {
  description = "Git branch, tag, or commit SHA to sync from"
  type        = string
  default     = "main"
}

variable "chart_path" {
  description = "Path to the Helm chart within the repository"
  type        = string
}

variable "app_namespace" {
  description = "Kubernetes namespace to deploy the app into"
  type        = string
}

variable "image" {
  description = "Docker image for the app (e.g. nginx:alpine)"
  type        = string
}

variable "replicas" {
  description = "Number of pod replicas"
  type        = number
  default     = 1
}

variable "port" {
  description = "Container port the app listens on"
  type        = number
  default     = 80
}
