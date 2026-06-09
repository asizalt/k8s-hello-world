terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "helm_values" {
  content = templatefile("${path.module}/values.yaml.tpl", {
    name     = var.name
    image    = var.image
    replicas = var.replicas
    port     = var.port
  })
  filename        = var.values_output_path
  file_permission = "0644"
}
