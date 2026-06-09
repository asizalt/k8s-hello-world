# k8s-hello-world

A "Hello World" HTTP service deployed to a local kind cluster via ArgoCD, with infrastructure config managed by Terragrunt.

## Architecture

```
terragrunt run-all apply (envs/dev/)
    │
    ├── cluster/      → creates kind cluster (1 control-plane + 2 workers)
    │
    ├── argocd/       → installs ArgoCD into the cluster via Helm
    │   (depends on cluster)
    │
    └── argocd-app/   → registers the ArgoCD Application with image/replicas/port
        (depends on cluster + argocd)    passed directly as Helm parameters
                │
                ▼
        ArgoCD pulls chart templates from Git
        + applies Terraform-supplied values
                │
                ▼
            kind cluster
```

No `values.yaml` generation or Git push required — Terraform passes config directly into the ArgoCD Application spec.

---

## Prerequisites

Install the following tools before starting.

### Windows

```powershell
winget install --id Hashicorp.Terraform
winget install --id Gruntwork.Terragrunt
winget install --id Helm.Helm
winget install --id Kubernetes.kubectl
winget install --id argoproj.argocd
```

> Docker Desktop must also be installed and running.
> kind: https://kind.sigs.k8s.io/docs/user/quick-start/#installation

### macOS

> TODO: add macOS (brew) instructions

### Linux

> TODO: add Linux instructions

---

## Step 1 — Run Terragrunt

```bash
cd envs/dev
terragrunt run-all init
terragrunt run-all apply
```

This runs all three modules in dependency order:
1. Creates the kind cluster (1 control-plane + 2 workers)
2. Installs ArgoCD via Helm
3. Registers the ArgoCD Application — ArgoCD immediately starts syncing

---

## Step 2 — Verify the deployment

Check sync status:

```bash
argocd app get hello-app
```

Or open the ArgoCD UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Visit https://localhost:8080 in your browser.

Get the initial admin password:

```bash
argocd admin initial-password -n argocd
```

---

## Step 3 — Access the app

```bash
kubectl port-forward svc/hello-app -n hello-app 8888:80
```

Open http://localhost:8888 — you should see the nginx welcome page.

---

## Teardown

```bash
cd envs/dev
terragrunt run-all destroy
```

Destroys in reverse dependency order: argocd-app → argocd → cluster.

---

## Changing the app config

All config lives in `envs/dev/argocd-app/terragrunt.hcl`:

```hcl
inputs = {
  image    = "nginx:alpine"
  replicas = 2
  port     = 80
}
```

Change a value and re-run `terragrunt apply` — Terraform updates the ArgoCD Application, ArgoCD re-syncs automatically.

---

## Repository Structure

```
k8s-hello-world/
├── modules/
│   ├── kind-cluster/           # Creates a local kind cluster
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── argocd/                 # Installs ArgoCD via Helm
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── argocd-app/             # Registers ArgoCD Application with Helm parameters
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── envs/
│   └── dev/
│       ├── cluster/
│       │   └── terragrunt.hcl
│       ├── argocd/
│       │   └── terragrunt.hcl  # depends on cluster
│       └── argocd-app/
│           └── terragrunt.hcl  # depends on cluster + argocd
├── helm/
│   └── hello-app/
│       ├── Chart.yaml
│       ├── values.yaml         # defaults only — real values come from Terraform
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── networkpolicy.yaml
│           └── _helpers.tpl
├── .github/
│   └── workflows/
│       └── lint.yml            # Helm lint on push/PR
└── README.md
```

---

## Resource Requests & Limits

| | CPU | Memory |
|---|---|---|
| requests | 50m | 64Mi |
| limits | 100m | 128Mi |

**Reasoning:** nginx serving a static page is extremely lightweight. 50m CPU and 64Mi RAM comfortably handles hundreds of requests/sec for a hello-world workload. Limits are set at 2x requests to allow short bursts without risking starvation of other pods on the node.

---

## NetworkPolicy

The `NetworkPolicy` allows:
- **Ingress:** only on the app's container port (80)
- **Egress:** all traffic (needed for DNS resolution and any upstream calls)

All other ingress is denied by default once the policy is applied.
