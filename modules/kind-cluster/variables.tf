variable "name" {
  description = "Kind cluster name"
  type        = string
  default     = "hello-world"
}

variable "k8s_version" {
  description = "Kubernetes version for the kind node image (e.g. v1.31.0)"
  type        = string
  default     = "v1.31.0"
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}
