# Loki Logging
The loki logging stack is a grafana project and a lightweight alternative to elastic logging stack.\
[https://github.com/grafana/loki](https://github.com/grafana/loki)

We use the provided helm charts to deploy loki logging with a values yaml to log also the systemd journal and setup prometheus monitoring for loki and a persistent volume.
```
$ cd ~/k3s-demo/applications/loki/
$ cat Chart.yaml 
apiVersion: v2
name: loki
description: Loki Logging Stack
type: application
version: 0.1.0
appVersion: "1.0"

dependencies:
- name: loki-stack
  version: 2.4.1
  repository: https://grafana.github.io/helm-charts

$ cat values.yaml 
loki-stack:
  loki:
    persistence:
      enabled: "true"
      size: "20Gi"
      storageClassName: "local-path"
    serviceMonitor:
      enabled: "true"
      additionalLabels:
        release: "monitoring"
  promtail:
    enabled: "true"
    extraScrapeConfigs:
      - job_name: journal
        journal:
          path: /var/log/journal
          max_age: 12h
          labels:
            job: systemd-journal
        relabel_configs:
          - source_labels: ['__journal__systemd_unit']
            target_label: 'unit'
          - source_labels: ['__journal__hostname']
            target_label: 'hostname'
    # Mount journal directory into promtail pods
    extraVolumes:
      - name: journal
        hostPath:
          path: /var/log/journal
    extraVolumeMounts:
      - name: journal
        mountPath: /var/log/journal
        readOnly: true
```
## Installation of Loki
Loki will be deployed by argocd. You can use the WebUI of argocd or the argocd cli to sync the loki app.
```
$ argocd login --insecure --username admin --password admin argocd.k3sdemo.lan
'admin:login' logged in successfully
Context 'argocd.k3sdemo.lan' updated
```
```
$ argocd app sync loki
TIMESTAMP                  GROUP                            KIND           NAMESPACE                  NAME                STATUS    HEALTH        HOOK  MESSAGE
2021-12-12T13:31:19+01:00                                 Secret                loki                  loki              OutOfSync  Missing              
2021-12-12T13:31:19+01:00   apps                      StatefulSet               loki                  loki              OutOfSync  Missing              
2021-12-12T13:31:19+01:00  policy                     PodSecurityPolicy                               loki              OutOfSync  Missing              
2021-12-12T13:31:19+01:00  rbac.authorization.k8s.io  ClusterRoleBinding              loki-promtail-clusterrolebinding  OutOfSync  Missing              
2021-12-12T13:31:19+01:00                                Service                loki                  loki              OutOfSync  Missing              
2021-12-12T13:31:19+01:00                                Service                loki         loki-headless              OutOfSync  Missing              
2021-12-12T13:31:19+01:00  monitoring.coreos.com      ServiceMonitor            loki                  loki              OutOfSync  Missing              
2021-12-12T13:31:19+01:00  rbac.authorization.k8s.io        Role                loki                  loki              OutOfSync  Missing              
2021-12-12T13:31:19+01:00  rbac.authorization.k8s.io  RoleBinding               loki         loki-promtail              OutOfSync  Missing              
2021-12-12T13:31:19+01:00  rbac.authorization.k8s.io        Role                loki         loki-promtail              OutOfSync  Missing              
2021-12-12T13:31:19+01:00                              ConfigMap                loki       loki-loki-stack              OutOfSync  Missing              
2021-12-12T13:31:19+01:00                              ConfigMap                loki  loki-loki-stack-test              OutOfSync  Missing              
2021-12-12T13:31:19+01:00                             ServiceAccount            loki                  loki              OutOfSync  Missing              
2021-12-12T13:31:19+01:00                             ServiceAccount            loki         loki-promtail              OutOfSync  Missing              
2021-12-12T13:31:19+01:00  policy                     PodSecurityPolicy                      loki-promtail              OutOfSync  Missing              
2021-12-12T13:31:19+01:00                              ConfigMap                loki         loki-promtail              OutOfSync  Missing              
2021-12-12T13:31:19+01:00   apps                       DaemonSet                loki         loki-promtail              OutOfSync  Missing              
2021-12-12T13:31:19+01:00  rbac.authorization.k8s.io  ClusterRole                     loki-promtail-clusterrole         OutOfSync  Missing              
2021-12-12T13:31:19+01:00  rbac.authorization.k8s.io  RoleBinding               loki                  loki              OutOfSync  Missing              
2021-12-12T13:31:23+01:00          Namespace                              loki   Running   Synced              namespace/loki created
2021-12-12T13:31:23+01:00  policy  PodSecurityPolicy                     loki-promtail    Synced  Missing              
2021-12-12T13:31:23+01:00  policy  PodSecurityPolicy                              loki    Synced  Missing              
2021-12-12T13:31:23+01:00             Secret        loki                  loki    Synced  Missing              
2021-12-12T13:31:23+01:00          ConfigMap        loki         loki-promtail    Synced  Missing              
2021-12-12T13:31:24+01:00          ConfigMap        loki       loki-loki-stack    Synced  Missing              
2021-12-12T13:31:24+01:00          ConfigMap        loki  loki-loki-stack-test    Synced  Missing              
2021-12-12T13:31:24+01:00         ServiceAccount        loki         loki-promtail    Synced  Missing              
2021-12-12T13:31:24+01:00                             ServiceAccount        loki                  loki         Synced  Missing              
2021-12-12T13:31:24+01:00  rbac.authorization.k8s.io  ClusterRole                 loki-promtail-clusterrole    Synced  Missing              
2021-12-12T13:31:24+01:00  rbac.authorization.k8s.io  ClusterRoleBinding              loki-promtail-clusterrolebinding    Synced  Missing              
2021-12-12T13:31:24+01:00  rbac.authorization.k8s.io        Role        loki                  loki    Synced  Missing              
2021-12-12T13:31:24+01:00  rbac.authorization.k8s.io        Role        loki         loki-promtail    Synced  Missing              
2021-12-12T13:31:24+01:00  rbac.authorization.k8s.io  RoleBinding        loki         loki-promtail    Synced  Missing              
2021-12-12T13:31:24+01:00  rbac.authorization.k8s.io  RoleBinding        loki                  loki    Synced  Missing              
2021-12-12T13:31:24+01:00            Service        loki                  loki    Synced  Healthy              
2021-12-12T13:31:24+01:00            Service        loki         loki-headless    Synced  Healthy              
2021-12-12T13:31:25+01:00   apps   DaemonSet        loki         loki-promtail    Synced  Progressing              
2021-12-12T13:31:25+01:00   apps  StatefulSet        loki                  loki    Synced  Progressing              
2021-12-12T13:31:25+01:00  policy                     PodSecurityPolicy        loki         loki-promtail   Running   Synced              podsecuritypolicy.policy/loki-promtail created
2021-12-12T13:31:25+01:00                                 Secret               loki                  loki    Synced  Missing              secret/loki created
2021-12-12T13:31:25+01:00                              ConfigMap               loki         loki-promtail    Synced  Missing              configmap/loki-promtail created
2021-12-12T13:31:25+01:00  rbac.authorization.k8s.io  RoleBinding              loki                  loki    Synced  Missing              rolebinding.rbac.authorization.k8s.io/loki reconciled. reconciliation required create
                           missing subjects added:
                                                      {Kind:ServiceAccount APIGroup: Name:loki Namespace:}. rolebinding.rbac.authorization.k8s.io/loki configured. Warning: resource rolebindings/loki is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
2021-12-12T13:31:25+01:00   apps                       DaemonSet            loki         loki-promtail         Synced   Progressing              daemonset.apps/loki-promtail created
2021-12-12T13:31:25+01:00                              Namespace                                  loki       Succeeded   Synced                  namespace/loki created
2021-12-12T13:31:25+01:00                              ConfigMap            loki       loki-loki-stack         Synced   Missing                  configmap/loki-loki-stack created
2021-12-12T13:31:25+01:00                             ServiceAccount        loki         loki-promtail         Synced   Missing                  serviceaccount/loki-promtail created
2021-12-12T13:31:25+01:00  rbac.authorization.k8s.io  ClusterRole           loki  loki-promtail-clusterrole   Running    Synced                  clusterrole.rbac.authorization.k8s.io/loki-promtail-clusterrole reconciled. reconciliation required create
                           missing rules added:
                                                      {Verbs:[get watch list] APIGroups:[] Resources:[nodes nodes/proxy services endpoints pods] ResourceNames:[] NonResourceURLs:[]}. clusterrole.rbac.authorization.k8s.io/loki-promtail-clusterrole configured. Warning: resource clusterroles/loki-promtail-clusterrole is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
2021-12-12T13:31:25+01:00  rbac.authorization.k8s.io        Role        loki                  loki    Synced  Missing              role.rbac.authorization.k8s.io/loki reconciled. reconciliation required create
                           missing rules added:
                                                      {Verbs:[use] APIGroups:[extensions] Resources:[podsecuritypolicies] ResourceNames:[loki] NonResourceURLs:[]}. role.rbac.authorization.k8s.io/loki configured. Warning: resource roles/loki is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
2021-12-12T13:31:25+01:00                                Service               loki                  loki    Synced   Healthy              service/loki created
2021-12-12T13:31:25+01:00  monitoring.coreos.com      ServiceMonitor           loki                  loki  OutOfSync  Missing              servicemonitor.monitoring.coreos.com/loki created
2021-12-12T13:31:25+01:00  policy                     PodSecurityPolicy        loki                  loki   Running    Synced              podsecuritypolicy.policy/loki created
2021-12-12T13:31:25+01:00  rbac.authorization.k8s.io        Role               loki         loki-promtail    Synced   Missing              role.rbac.authorization.k8s.io/loki-promtail reconciled. reconciliation required create
                           missing rules added:
                                                      {Verbs:[use] APIGroups:[extensions] Resources:[podsecuritypolicies] ResourceNames:[loki-promtail] NonResourceURLs:[]}. role.rbac.authorization.k8s.io/loki-promtail configured. Warning: resource roles/loki-promtail is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
2021-12-12T13:31:25+01:00  rbac.authorization.k8s.io  RoleBinding        loki         loki-promtail    Synced  Missing              rolebinding.rbac.authorization.k8s.io/loki-promtail reconciled. reconciliation required create
                           missing subjects added:
                                                      {Kind:ServiceAccount APIGroup: Name:loki-promtail Namespace:}. rolebinding.rbac.authorization.k8s.io/loki-promtail configured. Warning: resource rolebindings/loki-promtail is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
2021-12-12T13:31:25+01:00                              ConfigMap                loki  loki-loki-stack-test                Synced  Missing              configmap/loki-loki-stack-test created
2021-12-12T13:31:25+01:00                             ServiceAccount            loki                  loki                Synced  Missing              serviceaccount/loki created
2021-12-12T13:31:25+01:00  rbac.authorization.k8s.io  ClusterRoleBinding        loki  loki-promtail-clusterrolebinding   Running   Synced              clusterrolebinding.rbac.authorization.k8s.io/loki-promtail-clusterrolebinding reconciled. reconciliation required create
                           missing subjects added:
                                  {Kind:ServiceAccount APIGroup: Name:loki-promtail Namespace:loki}. clusterrolebinding.rbac.authorization.k8s.io/loki-promtail-clusterrolebinding configured. Warning: resource clusterrolebindings/loki-promtail-clusterrolebinding is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
2021-12-12T13:31:25+01:00            Service         loki         loki-headless    Synced  Healthy                  service/loki-headless created
2021-12-12T13:31:25+01:00   apps  StatefulSet        loki                  loki    Synced  Progressing              statefulset.apps/loki created
2021-12-12T13:31:25+01:00  monitoring.coreos.com  ServiceMonitor        loki                  loki    Synced  Missing              servicemonitor.monitoring.coreos.com/loki created

Name:               loki
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          loki
URL:                https://argocd.k3sdemo.lan/applications/loki
Repo:               https://github.com/dgo19/k3s-demo.git
Target:             HEAD
Path:               applications/loki
SyncWindow:         Sync Allowed
Sync Policy:        <none>
Sync Status:        Synced to HEAD (3dbfa52)
Health Status:      Progressing

Operation:          Sync
Sync Revision:      3dbfa52b57a860bcb003653fa5c8a127a06042c9
Phase:              Succeeded
Start:              2021-12-12 13:31:19 +0100 CET
Finished:           2021-12-12 13:31:25 +0100 CET
Duration:           6s
Message:            successfully synced (all tasks run)

GROUP                      KIND               NAMESPACE  NAME                       STATUS     HEALTH  HOOK  MESSAGE
                           Namespace                     loki                       Succeeded  Synced        namespace/loki created
policy                     PodSecurityPolicy  loki       loki-promtail              Running    Synced        podsecuritypolicy.policy/loki-promtail created
policy                     PodSecurityPolicy  loki       loki                       Running    Synced        podsecuritypolicy.policy/loki created
                           Secret             loki       loki                       Synced                   secret/loki created
                           ConfigMap          loki       loki-promtail              Synced                   configmap/loki-promtail created
                           ConfigMap          loki       loki-loki-stack            Synced                   configmap/loki-loki-stack created
                           ConfigMap          loki       loki-loki-stack-test       Synced                   configmap/loki-loki-stack-test created
                           ServiceAccount     loki       loki-promtail              Synced                   serviceaccount/loki-promtail created
                           ServiceAccount     loki       loki                       Synced                   serviceaccount/loki created
rbac.authorization.k8s.io  ClusterRole        loki       loki-promtail-clusterrole  Running    Synced        clusterrole.rbac.authorization.k8s.io/loki-promtail-clusterrole reconciled. reconciliation required create
                           missing rules added:
                                               {Verbs:[get watch list] APIGroups:[] Resources:[nodes nodes/proxy services endpoints pods] ResourceNames:[] NonResourceURLs:[]}. clusterrole.rbac.authorization.k8s.io/loki-promtail-clusterrole configured. Warning: resource clusterroles/loki-promtail-clusterrole is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
rbac.authorization.k8s.io  ClusterRoleBinding  loki  loki-promtail-clusterrolebinding  Running  Synced       clusterrolebinding.rbac.authorization.k8s.io/loki-promtail-clusterrolebinding reconciled. reconciliation required create
                           missing subjects added:
                                 {Kind:ServiceAccount APIGroup: Name:loki-promtail Namespace:loki}. clusterrolebinding.rbac.authorization.k8s.io/loki-promtail-clusterrolebinding configured. Warning: resource clusterrolebindings/loki-promtail-clusterrolebinding is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
rbac.authorization.k8s.io  Role  loki  loki  Synced            role.rbac.authorization.k8s.io/loki reconciled. reconciliation required create
                           missing rules added:
                                 {Verbs:[use] APIGroups:[extensions] Resources:[podsecuritypolicies] ResourceNames:[loki] NonResourceURLs:[]}. role.rbac.authorization.k8s.io/loki configured. Warning: resource roles/loki is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
rbac.authorization.k8s.io  Role  loki  loki-promtail  Synced            role.rbac.authorization.k8s.io/loki-promtail reconciled. reconciliation required create
                           missing rules added:
                                        {Verbs:[use] APIGroups:[extensions] Resources:[podsecuritypolicies] ResourceNames:[loki-promtail] NonResourceURLs:[]}. role.rbac.authorization.k8s.io/loki-promtail configured. Warning: resource roles/loki-promtail is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
rbac.authorization.k8s.io  RoleBinding  loki  loki  Synced            rolebinding.rbac.authorization.k8s.io/loki reconciled. reconciliation required create
                           missing subjects added:
                                        {Kind:ServiceAccount APIGroup: Name:loki Namespace:}. rolebinding.rbac.authorization.k8s.io/loki configured. Warning: resource rolebindings/loki is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
rbac.authorization.k8s.io  RoleBinding  loki  loki-promtail  Synced            rolebinding.rbac.authorization.k8s.io/loki-promtail reconciled. reconciliation required create
                           missing subjects added:
                                               {Kind:ServiceAccount APIGroup: Name:loki-promtail Namespace:}. rolebinding.rbac.authorization.k8s.io/loki-promtail configured. Warning: resource rolebindings/loki-promtail is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by  apply.  apply should only be used on resources created declaratively by either  create --save-config or  apply. The missing annotation will be patched automatically.
                           Service             loki  loki-headless                     Synced  Healthy           service/loki-headless created
                           Service             loki  loki                              Synced  Healthy           service/loki created
apps                       DaemonSet           loki  loki-promtail                     Synced  Progressing       daemonset.apps/loki-promtail created
apps                       StatefulSet         loki  loki                              Synced  Progressing       statefulset.apps/loki created
monitoring.coreos.com      ServiceMonitor      loki  loki                              Synced                    servicemonitor.monitoring.coreos.com/loki created
policy                     PodSecurityPolicy         loki                              Synced                    
policy                     PodSecurityPolicy         loki-promtail                     Synced                    
rbac.authorization.k8s.io  ClusterRole               loki-promtail-clusterrole         Synced                    
rbac.authorization.k8s.io  ClusterRoleBinding        loki-promtail-clusterrolebinding  Synced
```
The pods in the loki namespace should be in state running now.
```
$ kubectl -n loki get pods
NAME                  READY   STATUS    RESTARTS   AGE
loki-promtail-kxdkc   1/1     Running   0          2m59s
loki-0                1/1     Running   0          2m59s
```
You can view the logs in the [Grafana](https://grafana.k3sdemo.lan/) dashboard "Logging Dashboard via Loki".
