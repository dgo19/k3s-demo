# Prometheus Monitoring
## Installation
The prometheus monitoring stack has already been deployed in [Installation of k3s](install-k3s.md).
We use the helm charts of the [Prometheus Community Kubernetes Helm Charts](https://github.com/prometheus-community/helm-charts) with a custom values.yaml.
```
$ cd ~/k3s-demo/applications/monitoring/
$ cat Chart.yaml 
apiVersion: v2
name: monitoring
description: Prometheus Monitoring Stack
type: application
version: 0.1.0
appVersion: "1.0"

dependencies:
- name: kube-prometheus-stack
  version: 18.0.5
  repository: https://prometheus-community.github.io/helm-charts
```
```
$ cat values.yaml 
kube-prometheus-stack:
  alertmanager:
    ingress:
      enabled: true
      hosts:
        - alertmanager.k3sdemo.lan
      pathType: "ImplementationSpecific"
    alertmanagerSpec:
      storage:
        volumeClaimTemplate:
          spec:
            storageClassName: "local-path"
            resources:
              requests:
                storage: "2Gi"
  grafana:
    ingress:
      enabled: "true"
      hosts:
        - grafana.k3sdemo.lan
    additionalDataSources:
      - name: "loki"
        access: "proxy"
        orgId: "1"
        type: "loki"
        url: "http://loki.loki.svc.cluster.local:3100"
        version: "1"
    adminPassword: "admin"
    grafana.ini:
      users:
        viewers_can_edit: "false"
      auth:
        disable_login_form: "false"
        disable_signout_menu: "false"
      auth.anonymous:
          enabled: "true"
          org_role: "Viewer"
    dashboardProviders:
      dashboardproviders.yaml:
        apiVersion: 1
        providers:
          - name: default
            orgId: 1
            folder:
            type: file
            disableDeletion: true
            editable: false
            options:
              path: /var/lib/grafana/dashboards/default
    dashboards:
      default:
        Logging:
          gnetId: 12611
          revison: 1
          datasource: loki
        ArgoCD:
          gnetId: 14584
          revision: 1
          datasource: default
        WildFly:
          gnetId: 13489
          revision: 1
          datasource: default
    plugins:
      - grafana-piechart-panel
  kubeApiServer:
    enabled: "true"
  kubeControllerManager:
    enabled: "false"
  kubeDns:
    enabled: "false"
  kubeEtcd:
    enabled: "false"
  kubelet:
    enabled: "true"
  kubeProxy:
    enabled: "false"
  kubeScheduler:
    enabled: "false"
  prometheus:
    ingress:
      enabled: "true"
      hosts:
        - prometheus.k3sdemo.lan
      pathType: "ImplementationSpecific"
    prometheusSpec:
      storageSpec:
        volumeClaimTemplate:
          spec:
            storageClassName: "local-path"
            resources:
              requests:
                storage: "12Gi"
  prometheusOperator:
    admissionWebhooks:
      failurePolicy: "Ignore"
    prometheusSpec:
      retention: "14d"
      retentionSize: "10GB"
  defaultRules:
    rules:
      kubeScheduler: false
```
In case of a single ubuntu VM, add the required subdomain to /etc/hosts
```
$ sudo sed -i '/^127.0.0.1/ s/$/ prometheus\.k3sdemo\.lan/' /etc/hosts
$ sudo sed -i '/^127.0.0.1/ s/$/ grafana\.k3sdemo\.lan/' /etc/hosts
$ sudo sed -i '/^127.0.0.1/ s/$/ alertmanager\.k3sdemo\.lan/' /etc/hosts
```
## Prometheus Stack Components
### Grafana
Grafana provides dashboards with several prometheus metrics.
For this demo, you can access the dashboard with an anonymous read-only user. 
[https://grafana.k3sdemo.lan](https://grafana.k3sdemo.lan)
Click on the Dashboards-Icon on the left side and then "Manage". Most of the Dashboards are working.
When you want to see logs (loki dashboards), deploy the loki application in arcgocd. See [Loki Logging Stack](loki.md)

### Prometheus
Prometheus scrapes the metrics from metrics endpoints (http/https) and stores them on the configured persistent volume.
You can explore the metrics here: [https://prometheus.k3sdemo.lan](https://prometheus.k3sdemo.lan)

With is promql, the prometheus query language, you cann retrieve and plot the metrics from the prometheus data storage.
[https://prometheus.k3sdemo.lan/graph?g0.expr=node_load1&g0.tab=0&g0.stacked=0&g0.show_exemplars=0&g0.range_input=1h](https://prometheus.k3sdemo.lan/graph?g0.expr=node_load1&g0.tab=0&g0.stacked=0&g0.show_exemplars=0&g0.range_input=1h)

#### Metrics and ServiceMonitor
The node metrics e.g. are provided by the prometheus node-exporter pod.
```
$ kubectl -n monitoring get pods -o wide -l app=prometheus-node-exporter
NAME                                        READY   STATUS    RESTARTS   AGE   IP              NODE             NOMINATED NODE   READINESS GATES
monitoring-prometheus-node-exporter-pmv29   1/1     Running   8          39d   192.168.0.133   dgo-virtualbox   <none>           <none>
```
This node-exporter reads the linux performance metrics from the operating system and provides a prometheus metrics interface. It can be accessed via curl or web browser: [http://localhost:9100/metrics](http://localhost:9100/metrics)
```
$ curl http://localhost:9100/metrics
# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 1.1525e-05
go_gc_duration_seconds{quantile="0.25"} 4.6634e-05
go_gc_duration_seconds{quantile="0.5"} 7.963e-05
go_gc_duration_seconds{quantile="0.75"} 0.000114138
go_gc_duration_seconds{quantile="1"} 0.010962528
go_gc_duration_seconds_sum 0.051002005
go_gc_duration_seconds_count 165
# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 9
# HELP go_info Information about the Go environment.
# TYPE go_info gauge
go_info{version="go1.16.7"} 1
# HELP go_memstats_alloc_bytes Number of bytes allocated and still in use.
# TYPE go_memstats_alloc_bytes gauge
go_memstats_alloc_bytes 3.561168e+06

< output omitted>
```
You find the "load1" metric in this output, we already viewed in prometheus.
```
$ curl -s http://localhost:9100/metrics | grep "load1 "
# HELP node_load1 1m load average.
# TYPE node_load1 gauge
node_load1 0.82
```
Prometheus reads the ServiceMonitor resources in kubernetes and creates a configuration to scrape the metrics.
Here is the ServiceMonitor for the node-exporter:
```
$ kubectl -n monitoring get servicemonitor monitoring-kube-prometheus-node-exporter -o yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  annotations:
    meta.helm.sh/release-name: monitoring
    meta.helm.sh/release-namespace: monitoring
  creationTimestamp: "2021-11-02T14:42:19Z"
  generation: 1
  labels:
    app: kube-prometheus-stack-node-exporter
    app.kubernetes.io/instance: monitoring
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/part-of: kube-prometheus-stack
    app.kubernetes.io/version: 18.0.5
    chart: kube-prometheus-stack-18.0.5
    heritage: Helm
    release: monitoring
  name: monitoring-kube-prometheus-node-exporter
  namespace: monitoring
  resourceVersion: "51265"
  uid: 092496fb-ed73-4ca0-9bd2-7e617e861428
spec:
  endpoints:
  - port: metrics
  jobLabel: jobLabel
  selector:
    matchLabels:
      app: prometheus-node-exporter
      release: monitoring
```
## Alertmanager
Alertmanager WebUI: [https://alertmanager.k3sdemo.lan](https://alertmanager.k3sdemo.lan)

There are still some alarms in this demo - k3s does not have all of the monitored components like a vanilla k8s.

The alertmanager alarms are configured by the resource PrometheusRule. You configure each alarm with PromQL expressions and a custom alarm message. Alertmanager checks the metrics for these expressions and displays an alert. It can also send this alert via email, webhook, ...
```
$ kubectl -n monitoring get prometheusrule monitoring-kube-prometheus-node-exporter -o yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  annotations:
    meta.helm.sh/release-name: monitoring
    meta.helm.sh/release-namespace: monitoring
    prometheus-operator-validated: "true"
  creationTimestamp: "2021-11-02T14:42:19Z"
  generation: 1
  labels:
    app: kube-prometheus-stack
    app.kubernetes.io/instance: monitoring
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/part-of: kube-prometheus-stack
    app.kubernetes.io/version: 18.0.5
    chart: kube-prometheus-stack-18.0.5
    heritage: Helm
    release: monitoring
  name: monitoring-kube-prometheus-node-exporter
  namespace: monitoring
  resourceVersion: "51269"
  uid: 7d5a2aa0-72af-40f0-a5e8-998b066dbf57
spec:
  groups:
  - name: node-exporter
    rules:
    - alert: NodeFilesystemSpaceFillingUp
      annotations:
        description: Filesystem on {{ $labels.device }} at {{ $labels.instance }}
          has only {{ printf "%.2f" $value }}% available space left and is filling
          up.
        runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-nodefilesystemspacefillingup
        summary: Filesystem is predicted to run out of space within the next 24 hours.
      expr: |-
        (
          node_filesystem_avail_bytes{job="node-exporter",fstype!=""} / node_filesystem_size_bytes{job="node-exporter",fstype!=""} * 100 < 40
        and
          predict_linear(node_filesystem_avail_bytes{job="node-exporter",fstype!=""}[6h], 24*60*60) < 0
        and
          node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
        )
      for: 1h
      labels:
        severity: warning
    - alert: NodeFilesystemSpaceFillingUp
      annotations:
        description: Filesystem on {{ $labels.device }} at {{ $labels.instance }}
          has only {{ printf "%.2f" $value }}% available space left and is filling
          up fast.
        runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-nodefilesystemspacefillingup
        summary: Filesystem is predicted to run out of space within the next 4 hours.
      expr: |-
        (
          node_filesystem_avail_bytes{job="node-exporter",fstype!=""} / node_filesystem_size_bytes{job="node-exporter",fstype!=""} * 100 < 15
        and
          predict_linear(node_filesystem_avail_bytes{job="node-exporter",fstype!=""}[6h], 4*60*60) < 0
        and
          node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
        )
      for: 1h
      labels:
        severity: critical
    - alert: NodeFilesystemAlmostOutOfSpace
      annotations:
        description: Filesystem on {{ $labels.device }} at {{ $labels.instance }}
          has only {{ printf "%.2f" $value }}% available space left.
        runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-nodefilesystemalmostoutofspace
        summary: Filesystem has less than 5% space left.
      expr: |-
        (
          node_filesystem_avail_bytes{job="node-exporter",fstype!=""} / node_filesystem_size_bytes{job="node-exporter",fstype!=""} * 100 < 5
        and
          node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
        )
      for: 1h
      labels:
        severity: warning
        and
          predict_linear(node_filesystem_files_free{job="node-exporter",fstype!=""}[6h], 24*60*60) < 0
        and
          node_filesystem_readonly{job="node-exporter",fstype!=""} == 0
        )
      for: 1h
      labels:
        severity: warning

< output omitted >
```
