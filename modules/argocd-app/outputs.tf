output "app_name" {
  description = "Name of the created ArgoCD Application"
  value       = kubernetes_manifest.argocd_application.manifest.metadata.name
}

output "app_namespace" {
  description = "Namespace the app is deployed into"
  value       = kubernetes_manifest.argocd_application.manifest.spec.destination.namespace
}
