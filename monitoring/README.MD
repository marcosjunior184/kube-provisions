# Prerequisites
```bash
# Install Helm if you don't have it
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add the Prometheus community repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```