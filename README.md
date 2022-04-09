# k3s demo

## Requirements
- linux distribution (instructions for ubuntu/debian with apt)
- amd64 and arm64 are working. See limitations below.
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

## limitations by architecture
There are some container images missing for arm64, so not all applications are working.
| application               | amd64              | arm64              | comment |
|---|---|---|---|
| argocd                    | :heavy_check_mark: | :heavy_check_mark: | |
| configmaps                | :heavy_check_mark: | :heavy_check_mark: | |
| gogs                      | :heavy_check_mark: | :heavy_check_mark: | |
| ingress-nginx             | :heavy_check_mark: | :heavy_check_mark: | |
| istio-bookinfo            | :heavy_check_mark: | :no_entry:         | |
| istio-bookinfo-bombardier | :heavy_check_mark: | :no_entry:         | |
| istio-system              | :heavy_check_mark: | :no_entry:         | |
| istio-system-jaeger       | :heavy_check_mark: | :heavy_check_mark: | |
| keycloak                  | :heavy_check_mark: | :no_entry:         | |
| kubernetes-dashboard      | :heavy_check_mark: | :heavy_check_mark: | |
| loki                      | :heavy_check_mark: | :heavy_check_mark: | |
| mariadb-ephemeral         | :heavy_check_mark: | :heavy_check_mark: | phpmyadmin image not available, mariadb works |
| mariadb-pv                | :heavy_check_mark: | :heavy_check_mark: | phpmyadmin image not available, mariadb works |
| monitoring                | :heavy_check_mark: | :heavy_check_mark: | |
| postgres-operator         | :heavy_check_mark: | :no_entry:         | |
| registry                  | :heavy_check_mark: | :heavy_check_mark: | |
| sealed-secrets            | :heavy_check_mark: | :heavy_check_mark: | |
| starboard                 | :heavy_check_mark: | :no_entry:         | |
| tekton-pipelines          | :heavy_check_mark: | :heavy_check_mark: | |
| test-my-webserver         | :heavy_check_mark: | :heavy_check_mark: | |
| test-nginx-dev            | :heavy_check_mark: | :heavy_check_mark: | |
| test-nginx                | :heavy_check_mark: | :heavy_check_mark: | |
