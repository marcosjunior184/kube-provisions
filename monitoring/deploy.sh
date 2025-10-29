#!/bin/bash
# deploy-monitoring-manual.sh

echo "Deploying Prometheus and Grafana..."

# Apply all YAML files in order
kubectl apply -f 01-namespace.yaml
kubectl apply -f 02-prometheus-config.yaml
kubectl apply -f 03-prometheus-deployment.yaml
kubectl apply -f 04-prometheus-service.yaml
kubectl apply -f 05-grafana-deployment.yaml
kubectl apply -f 06-grafana-datasources.yaml
kubectl apply -f 07-grafana-service.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=prometheus -n monitoring --timeout=300s
kubectl wait --for=condition=ready pod -l app=grafana -n monitoring --timeout=300s

echo "=== Services ==="
kubectl get svc -n monitoring

echo "=== Pods ==="
kubectl get pods -n monitoring

echo "=== Deployment Complete ==="
echo "Grafana URL: http://<GRAFANA_EXTERNAL_IP>"
echo "Prometheus URL: http://<PROMETHEUS_EXTERNAL_IP>"
echo "Grafana credentials: admin/admin"