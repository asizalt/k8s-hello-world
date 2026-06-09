output "cluster_name" {
  description = "Name of the kind cluster"
  value       = kind_cluster.this.name
}

output "endpoint" {
  description = "Kubernetes API server endpoint"
  value       = kind_cluster.this.endpoint
}

output "kubeconfig" {
  description = "Kubeconfig for connecting to the cluster"
  value       = kind_cluster.this.kubeconfig
  sensitive   = true
}
