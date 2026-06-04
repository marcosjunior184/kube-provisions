helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus \
  --namespace monitoring -f values/01.prometheus-values.yaml 

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install loki grafana/loki \
  -n monitoring \
  -f values/02.loki-values.yaml


helm install promtail grafana/promtail \
  -n monitoring \
  -f values/03.promtail-values.yaml 


  helm install grafana grafana/grafana  \
  -n monitoring \
  -f values/04.grafana-values.yaml