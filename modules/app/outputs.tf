output "values_file_path" {
  description = "Absolute path to the generated Helm values.yaml"
  value       = local_file.helm_values.filename
}

output "app_name" {
  description = "Application name passed to the module"
  value       = var.name
}

output "image" {
  description = "Docker image used"
  value       = var.image
}
