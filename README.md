# Kubernetes Status Page

Helm-deployed status page application with Prometheus monitoring, Grafana dashboards, and automated CI/CD pipeline.

## 🏗️ Architecture
```
GitHub Push → Webhook → Jenkins
                          ↓
                    Lint → Test → Deploy
                          ↓
                    Kubernetes Cluster
                          ↓
              ┌───────────┴───────────┐
         Status Page            Prometheus
              ↓                       ↓
          Service                  Grafana
```

## 🚀 Features

- **Automated CI/CD**: Git push triggers deployment pipeline
- **Health Monitoring**: Prometheus metrics collection
- **Visualization**: Grafana dashboards for uptime and performance
- **Helm Management**: Declarative K8s deployments
- **Webhook Integration**: GitHub → Jenkins automation

## Quick Start
### Prerequisites

- Docker
- Minikube (or K8s cluster)
- kubectl
- Helm 3.x

### 1. Setup Environment
```bash
# Install Helm
./get_helm.sh

# Start Minikube
minikube start --driver=docker
```

### 2. Deploy Application
```bash
# Deploy status page
helm install status-page ./status-page --set service.type=NodePort

# Get URL
minikube service status-page --url

# Test endpoint
curl $(minikube service status-page --url)
# Returns: {"status": "healthy", "timestamp": "..."}
```

### 3. Install Monitoring Stack
```bash
# Add Prometheus community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus + Grafana
helm install prometheus-stack prometheus-community/kube-prometheus-stack \
  -f prometheus-custom-values.yaml \
  --namespace monitoring \
  --create-namespace
```

### 4. Access Dashboards

**Prometheus:**
```bash
kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-prometheus 9090:9090
# Navigate to: http://localhost:9090
# Query: up{job="status-page"}
```

**Grafana:**
```bash
kubectl port-forward -n monitoring svc/prometheus-stack-grafana 3000:80
# Navigate to: http://localhost:3000
# Username: admin
# Password: prom-operator (default)

# Import dashboard: grafana-status-dashboard.json
```

## CI/CD Pipeline

**Trigger**: Push to `main` branch

**Flow:**
1. **Lint**: Validates Helm chart syntax
2. **Test**: Renders templates and checks for errors
3. **Deploy**: Applies changes to Kubernetes cluster

**Configuration:**
- GitHub webhook setup required
- Use ngrok for local testing: `ngrok http 8080`
- Configure webhook URL in GitHub repo settings

### Jenkins Setup
```groovy
// Jenkinsfile stages:
1. Checkout code from Git
2. Helm lint status-page/
3. Helm template validation
4. Helm upgrade --install (on main branch only)
```

## Monitoring

### Prometheus Metrics

The status page exposes metrics at `/metrics`:
- `app_requests_total`: Total requests count
- `app_request_duration_seconds`: Request latency
- `up`: Service health (1=up, 0=down)

### Grafana Dashboards

**Status Dashboard** includes:
- Uptime percentage
- Request rate
- Response time (p50, p95, p99)
- Error rate
- Scrape duration

## Configuration

### Helm Values
```yaml
# values.yaml
replicaCount: 2
image:
  repository: status-page
  tag: latest
service:
  type: NodePort  # or ClusterIP for internal
  port: 80
resources:
  limits:
    cpu: 100m
    memory: 128Mi
```

### Prometheus ServiceMonitor
```yaml
# Automatically discovers and scrapes /metrics endpoint
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: status-page
spec:
  selector:
    matchLabels:
      app: status-page
  endpoints:
  - port: http
    interval: 30s
```

##  Testing

### Health Check
```bash
# Check service health
curl http://<service-url>/health

# Expected response:
{
  "status": "healthy",
  "timestamp": "2024-11-12T10:30:00Z",
  "version": "1.0.0"
}
```

### Load Testing
```bash
# Generate synthetic load
for i in {1..100}; do 
  curl -s http://<service-url>/ > /dev/null
done

# Check metrics in Prometheus
# Query: rate(app_requests_total[5m])
```

##  Tech

- **Kubernetes**: Container orchestration
- **Helm**: Package manager for K8s
- **Prometheus**: Metrics and monitoring
- **Grafana**: Visualization and dashboards
- **Jenkins**: CI/CD automation
- **GitHub**: Source control and webhooks

## 

- ✅ Declarative deployments (Helm charts)
- ✅ Automated testing (lint + template validation)
- ✅ Continuous deployment (Git → Jenkins → K8s)
- ✅ Monitoring and observability (Prometheus + Grafana)
- ✅ Health checks and readiness probes
- ✅ Resource limits and requests defined

## 📖 Common Operations

### Update Application
```bash
# Update values
helm upgrade status-page ./status-page --set image.tag=v2.0.0

# View history
helm history status-page

# Rollback if needed
helm rollback status-page 1
```

### Scale Application
```bash
# Scale replicas
helm upgrade status-page ./status-page --set replicaCount=3
```

### View Logs
```bash
# Get pods
kubectl get pods -l app=status-page

# View logs
kubectl logs -f <pod-name>
```

### Debug Issues
```bash
# Describe pod
kubectl describe pod <pod-name>

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Test connectivity
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
```
test
test
