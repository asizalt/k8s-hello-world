output "namespace" {
  description = "Namespace ArgoCD was installed into"
  value       = helm_release.argocd.namespace
}

output "argocd_version" {
  description = "Installed ArgoCD Helm chart version"
  value       = helm_release.argocd.version
}
