replicaCount: ${replicas}

image: ${image}
imagePullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: ${port}

containerPort: ${port}

appName: ${name}

# Resource requests guarantee minimum CPU/memory for the pod.
# Resource limits cap usage to prevent a runaway process starving other pods.
# Reasoning:
#   nginx serving a static page is extremely lightweight.
#   50m CPU / 64Mi RAM is enough for hundreds of req/s on a hello-world workload.
#   Limits are set at 2x requests to allow short bursts without risk.
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 100m
    memory: 128Mi

networkPolicy:
  enabled: true
