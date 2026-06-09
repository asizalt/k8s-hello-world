variable "name" {
  description = "Application name"
  type        = string
}

variable "image" {
  description = "Docker image (e.g. nginx:alpine)"
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

variable "values_output_path" {
  description = "Absolute path where the generated values.yaml will be written"
  type        = string
}
