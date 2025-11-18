# Kubernetes Cluster Setup

Local Kubernetes development environment using Minikube with Terraform provisioning.

## Features

- Minikube cluster with configurable resources
- Terraform-managed infrastructure
- Docker driver for lightweight deployment
- Ingress controller enabled
- Multi-node support

## Quick Start
```bash
git clone https://github.com/digital-knife/k8s-cluster.git
cd k8s-cluster/terraform
terraform init
terraform apply

# Verify cluster
kubectl get nodes
kubectl get pods -A
```

## Project Structure
```
terraform/
├── main.tf                     # Minikube cluster definition
├── variables.tf                # Configurable parameters
├── outputs.tf                  # Cluster information
└── providers.tf                # Terraform/Kubernetes providers

manifests/                      # Kubernetes resources
└── (deployment examples)
```

## Configuration

Edit `terraform/variables.tf` to customize:

**Cluster:** CPUs, memory, Kubernetes version, nodes

**Networking:** Driver (docker/virtualbox/kvm2)

## Common Commands
```bash
# Start/stop cluster
minikube start
minikube stop

# Access dashboard
minikube dashboard

# SSH into node
minikube ssh

# Delete cluster
terraform destroy
```

## Resource Allocation

Default configuration:
- CPUs: 2
- Memory: 4GB
- Kubernetes: v1.28.3
- Nodes: 1

Adjust in `variables.tf` for larger workloads.

## Troubleshooting

**Issue:** Minikube won't start
- Check Docker is running
- Verify available system resources

**Issue:** Connection refused
- Ensure minikube tunnel is running
- Check service/ingress configuration
