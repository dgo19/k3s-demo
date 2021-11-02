# k3s demo

## Requirements
- linux distribution
- 20 GB in /var
- 6 GB RAM
- 2 Cores
- addition packages
  - curl
  - git
  - sudo

[Installation of k3s](install-k3s.md)

## App Deployments
- Pods, Deployment, Service, Ingress
  - [nginx webserver example](test-my-webserver.md)
- ConfigMaps
  - [nginx webserver with configmaps](configmap-webserver.md)
- ArgoCD
  - [ArgoCD Deployment and first steps](argocd.md)
  - [ArgoCD Application Deployment](argocd-apps.md)
- Monitoring
  - [Monitoring (Grafana, Prometheus, Alertmanager, Node-Exporter)](prometheus.md)
- Logging
  - [Loki Logging Stack](loki.md)
