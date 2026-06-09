locals {
  env          = "dev"
  cluster_name = "hello-world-dev"
  k8s_version  = "v1.31.0"
  worker_count = 2

  argocd_chart_version = "7.3.4"

  repo_url        = "https://github.com/asizalt/k8s-hello-world"
  target_revision = "main"
  chart_path      = "helm/hello-app"
  app_namespace   = "hello-app"

  app_name = "hello-app"
  image    = "nginx:alpine"
  replicas = 2
  port     = 80
}
