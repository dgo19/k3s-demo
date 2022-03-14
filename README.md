# k3s demo

## Requirements
- linux distribution (instructions for ubuntu/debian with apt)
- 40 GB in /var (50 GB total disk size)
- 6 GB RAM
- 3 Cores
- additional packages
  - curl
  - git
  - sudo
  - apache2-utils

## Installation
You can choose between a quick automatic installation with an ansible-playbook or you can run the required steps manually.

### Quickstart ansible-playbook (tested on ubuntu)
setup: [Installation by ansible-playbook](install-k3s-playbook.md)
- k3s, shell env, certificates, /etc/hosts for subdomains *.k3sdemo.lan
- ingress-nginx
- monitoring stack (prometheus, grafana, alertmanager)
- argocd
- kubernetes-dashboard
- sealed-secrets
- loki logging

### Manual Installation
- basic installtion tasks: [Installation of k3s](install-k3s.md)
- ArgoCD
  - [ArgoCD Deployment and first steps](argocd.md)
  - [ArgoCD Application Deployment](argocd-apps.md)
- Monitoring
  - [Monitoring (Grafana, Prometheus, Alertmanager, Node-Exporter)](prometheus.md)
- Logging
  - [Loki Logging Stack](loki.md)

## App Deployments
- Pods, Deployment, Service, Ingress
  - [nginx webserver example](test-my-webserver.md)
- ConfigMaps
  - [nginx webserver with configmaps](configmap-webserver.md)
