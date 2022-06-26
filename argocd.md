# Argo CD Deployment & first steps
In case of a single ubuntu VM, add the required subdomain to /etc/hosts
```
$ sudo sed -i '/^127.0.0.1/ s/$/ argocd\.k3sdemo\.lan/' /etc/hosts
```
Deploy Argo CD.
```
$ cd ~/k3s-demo/argocd/
$ kubectl apply -k .
namespace/argocd created
customresourcedefinition.apiextensions.k8s.io/applications.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/appprojects.argoproj.io created
serviceaccount/argocd-application-controller created
serviceaccount/argocd-dex-server created
serviceaccount/argocd-redis created
serviceaccount/argocd-server created
role.rbac.authorization.k8s.io/argocd-application-controller created
role.rbac.authorization.k8s.io/argocd-dex-server created
role.rbac.authorization.k8s.io/argocd-server created
clusterrole.rbac.authorization.k8s.io/argocd-application-controller created
clusterrole.rbac.authorization.k8s.io/argocd-server created
rolebinding.rbac.authorization.k8s.io/argocd-application-controller created
rolebinding.rbac.authorization.k8s.io/argocd-dex-server created
rolebinding.rbac.authorization.k8s.io/argocd-redis created
rolebinding.rbac.authorization.k8s.io/argocd-server created
clusterrolebinding.rbac.authorization.k8s.io/argocd-application-controller created
clusterrolebinding.rbac.authorization.k8s.io/argocd-server created
configmap/argocd-cm created
configmap/argocd-cmd-params-cm created
configmap/argocd-gpg-keys-cm created
configmap/argocd-rbac-cm created
configmap/argocd-ssh-known-hosts-cm created
configmap/argocd-tls-certs-cm created
secret/argocd-secret created
service/argocd-dex-server created
service/argocd-metrics created
service/argocd-redis created
service/argocd-repo-server created
service/argocd-server created
service/argocd-server-metrics created
deployment.apps/argocd-dex-server created
deployment.apps/argocd-redis created
deployment.apps/argocd-repo-server created
deployment.apps/argocd-server created
statefulset.apps/argocd-application-controller created
sealedsecret.bitnami.com/argocd-secret created
servicemonitor.monitoring.coreos.com/argocd-metrics created
servicemonitor.monitoring.coreos.com/argocd-repo-server-metrics created
servicemonitor.monitoring.coreos.com/argocd-server-metrics created
ingress.networking.k8s.io/ingress-argocd-server created
networkpolicy.networking.k8s.io/argocd-application-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-dex-server-network-policy created
networkpolicy.networking.k8s.io/argocd-redis-network-policy created
networkpolicy.networking.k8s.io/argocd-repo-server-network-policy created
networkpolicy.networking.k8s.io/argocd-server-network-policy created
```
verify the pods are running and review the deployment
```
$ kubectl -n argocd get pods
NAME                                  READY   STATUS              RESTARTS   AGE
argocd-dex-server-5b46f9bcd4-hrbcq    0/1     Init:0/1            0          20s
argocd-redis-d486999b7-mlthc          0/1     ContainerCreating   0          20s
argocd-repo-server-6986455545-gglqp   0/1     Init:0/1            0          20s
argocd-server-7865d5ff6d-6h7xg        0/1     ContainerCreating   0          20s
argocd-application-controller-0       0/1     ContainerCreating   0          20s

$ kubectl -n argocd get pods
NAME                                  READY   STATUS    RESTARTS   AGE
argocd-redis-d486999b7-mlthc          1/1     Running   0          106s
argocd-server-7865d5ff6d-6h7xg        1/1     Running   0          106s
argocd-application-controller-0       1/1     Running   0          106s
argocd-dex-server-5b46f9bcd4-hrbcq    1/1     Running   0          106s
argocd-repo-server-6986455545-gglqp   1/1     Running   0          106s

$ kubectl -n argocd get svc
argocd-dex-server       ClusterIP   10.43.252.201   <none>        5556/TCP,5557/TCP,5558/TCP   89s
argocd-metrics          ClusterIP   10.43.155.73    <none>        8082/TCP                     89s
argocd-redis            ClusterIP   10.43.116.214   <none>        6379/TCP                     89s
argocd-repo-server      ClusterIP   10.43.53.121    <none>        8081/TCP,8084/TCP            89s
argocd-server           ClusterIP   10.43.115.0     <none>        80/TCP,443/TCP               89s
argocd-server-metrics   ClusterIP   10.43.3.109     <none>        8083/TCP                     89s

$ kubectl -n argocd get ingress
NAME                    CLASS    HOSTS                ADDRESS         PORTS   AGE
ingress-argocd-server   <none>   argocd.k3sdemo.lan   192.168.0.133   80      112s
```
Download the commandline client
If you are on arm64 architecture, replace the amd64 by arm64 in the url.
```
$ curl -L -o ~/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.2/argocd-linux-amd64
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   626  100   626    0     0   2454      0 --:--:-- --:--:-- --:--:--  2454
100 85.3M  100 85.3M    0     0   9.8M      0  0:00:08  0:00:08 --:--:-- 11.3M
$ chmod +x ~/bin/argocd 
```
Open the web-ui (https://argocd.k3sdemo.lan/) or login by command line client.
The following tasks can be done by cli or web ui.
```
$ argocd login --insecure --username admin --password admin argocd.k3sdemo.lan
'admin:login' logged in successfully
Context 'argocd.k3sdemo.lan' updated
```
Review the cluster, project, repo and apps.
```
$ argocd cluster list
SERVER                          NAME        VERSION  STATUS   MESSAGE
https://kubernetes.default.svc  in-cluster           Unknown  Cluster has no application and not being monitored.
```
```
$ argocd repo list
TYPE  NAME                  REPO                                                INSECURE  OCI    LFS    CREDS  STATUS      MESSAGE
git   dgo19-k3s-demo        https://github.com/dgo19/k3s-demo.git               false     false  false  false  Successful  
helm  grafana               https://grafana.github.io/helm-charts               false     false  false  false  Successful  
helm  prometheus-community  https://prometheus-community.github.io/helm-charts  false     false  false  false  Successful  
```
```
$ argocd proj list
NAME     DESCRIPTION  DESTINATIONS  SOURCES  CLUSTER-RESOURCE-WHITELIST  NAMESPACE-RESOURCE-BLACKLIST  SIGNATURE-KEYS  ORPHANED-RESOURCES
default               *,*           *        */*                         <none>                        <none>          disabled
```
```
$ argocd app list
NAME  CLUSTER  NAMESPACE  PROJECT  STATUS  HEALTH  SYNCPOLICY  CONDITIONS  REPO  PATH  TARGET
```
Create the first argocd application by applying the yaml-file - argocd itself.
```
$ kubectl apply -f application-argocd.yaml 
application.argoproj.io/argocd created
```
Now there is an application argocd in status OutOfSync.
```
$ argocd app list
NAME    CLUSTER                         NAMESPACE  PROJECT  STATUS     HEALTH   SYNCPOLICY  CONDITIONS  REPO                                   PATH    TARGET
argocd  https://kubernetes.default.svc  argocd     default  OutOfSync  Healthy  <none>      <none>      https://github.com/dgo19/k3s-demo.git  argocd  HEAD
```
```
$ argocd app diff argocd
===== /ConfigMap argocd/argocd-cm ======
12a13
>     app.kubernetes.io/instance: argocd
===== /ConfigMap argocd/argocd-gpg-keys-cm ======
7a8
>     app.kubernetes.io/instance: argocd
===== /ConfigMap argocd/argocd-rbac-cm ======
7a8
>     app.kubernetes.io/instance: argocd
===== /ConfigMap argocd/argocd-ssh-known-hosts-cm ======
16a17
>     app.kubernetes.io/instance: argocd
===== /ConfigMap argocd/argocd-tls-certs-cm ======
7a8
>     app.kubernetes.io/instance: argocd
===== /Namespace /argocd ======
7a8
>     app.kubernetes.io/instance: argocd
===== /Secret argocd/argocd-secret ======
12a13
>     app.kubernetes.io/instance: argocd
===== /Service argocd/argocd-dex-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== /Service argocd/argocd-metrics ======
8a9
>     app.kubernetes.io/instance: argocd
===== /Service argocd/argocd-redis ======
8a9
>     app.kubernetes.io/instance: argocd
===== /Service argocd/argocd-repo-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== /Service argocd/argocd-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== /Service argocd/argocd-server-metrics ======
8a9
>     app.kubernetes.io/instance: argocd
===== /ServiceAccount argocd/argocd-application-controller ======
8a9
>     app.kubernetes.io/instance: argocd
===== /ServiceAccount argocd/argocd-dex-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== /ServiceAccount argocd/argocd-redis ======
8a9
>     app.kubernetes.io/instance: argocd
===== /ServiceAccount argocd/argocd-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== apps/Deployment argocd/argocd-dex-server ======
10a11
>     app.kubernetes.io/instance: argocd
===== apps/Deployment argocd/argocd-redis ======
10a11
>     app.kubernetes.io/instance: argocd
===== apps/Deployment argocd/argocd-repo-server ======
10a11
>     app.kubernetes.io/instance: argocd
===== apps/Deployment argocd/argocd-server ======
10a11
>     app.kubernetes.io/instance: argocd
===== apps/StatefulSet argocd/argocd-application-controller ======
9a10
>     app.kubernetes.io/instance: argocd
===== networking.k8s.io/Ingress argocd/ingress-argocd-server ======
10a11,12
>   labels:
>     app.kubernetes.io/instance: argocd
===== networking.k8s.io/NetworkPolicy argocd/argocd-application-controller-network-policy ======
7a8,9
>   labels:
>     app.kubernetes.io/instance: argocd
===== networking.k8s.io/NetworkPolicy argocd/argocd-dex-server-network-policy ======
7a8,9
>   labels:
>     app.kubernetes.io/instance: argocd
===== networking.k8s.io/NetworkPolicy argocd/argocd-redis-network-policy ======
7a8,9
>   labels:
>     app.kubernetes.io/instance: argocd
===== networking.k8s.io/NetworkPolicy argocd/argocd-repo-server-network-policy ======
7a8,9
>   labels:
>     app.kubernetes.io/instance: argocd
===== networking.k8s.io/NetworkPolicy argocd/argocd-server-network-policy ======
7a8,9
>   labels:
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/ClusterRole /argocd-application-controller ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/ClusterRole /argocd-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/ClusterRoleBinding /argocd-application-controller ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/ClusterRoleBinding /argocd-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/Role argocd/argocd-application-controller ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/Role argocd/argocd-dex-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/Role argocd/argocd-redis ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/Role argocd/argocd-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/RoleBinding argocd/argocd-application-controller ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/RoleBinding argocd/argocd-dex-server ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/RoleBinding argocd/argocd-redis ======
8a9
>     app.kubernetes.io/instance: argocd
===== rbac.authorization.k8s.io/RoleBinding argocd/argocd-server ======
8a9
>     app.kubernetes.io/instance: argocd
```
The argocd labels are missing in the deployed application and this is fixed by an argocd sync.
```
$ argocd app sync argocd
TIMESTAMP                  GROUP                            KIND                 NAMESPACE                  NAME                            STATUS    HEALTH        HOOK  MESSAGE
2021-07-18T17:42:31+02:00                                Service                    argocd         argocd-server                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00                             ServiceAccount                argocd  argocd-application-controller                 OutOfSync                       
2021-07-18T17:42:31+02:00   apps                      Deployment                    argocd          argocd-redis                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  networking.k8s.io             Ingress                    argocd  ingress-argocd-server                         OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-repo-server-network-policy             OutOfSync                       
2021-07-18T17:42:31+02:00                              ConfigMap                    argocd   argocd-tls-certs-cm                          OutOfSync                       
2021-07-18T17:42:31+02:00                                Service                    argocd    argocd-repo-server                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-application-controller-network-policy  OutOfSync                       
2021-07-18T17:42:31+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-server-network-policy                  OutOfSync                       
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io  RoleBinding                   argocd  argocd-application-controller                 OutOfSync                       
2021-07-18T17:42:31+02:00                              Namespace                                          argocd                          OutOfSync                       
2021-07-18T17:42:31+02:00                                Service                    argocd        argocd-metrics                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00                                Service                    argocd  argocd-server-metrics                         OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io  ClusterRoleBinding                    argocd-application-controller                 OutOfSync                       
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io        Role                    argocd          argocd-redis                          OutOfSync                       
2021-07-18T17:42:31+02:00                              ConfigMap                    argocd             argocd-cm                          OutOfSync                       
2021-07-18T17:42:31+02:00                                Service                    argocd     argocd-dex-server                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-dex-server-network-policy              OutOfSync                       
2021-07-18T17:42:31+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-redis-network-policy                   OutOfSync                       
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io  ClusterRole                           argocd-application-controller                 OutOfSync                       
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io  ClusterRoleBinding                           argocd-server                          OutOfSync                       
2021-07-18T17:42:31+02:00                              ConfigMap                    argocd  argocd-ssh-known-hosts-cm                     OutOfSync                       
2021-07-18T17:42:31+02:00                             ServiceAccount                argocd          argocd-redis                          OutOfSync                       
2021-07-18T17:42:31+02:00  apiextensions.k8s.io       CustomResourceDefinition              applications.argoproj.io                        Synced                        
2021-07-18T17:42:31+02:00  apiextensions.k8s.io       CustomResourceDefinition              appprojects.argoproj.io                         Synced                        
2021-07-18T17:42:31+02:00   apps                      Deployment                    argocd    argocd-repo-server                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io  ClusterRole                                  argocd-server                          OutOfSync                       
2021-07-18T17:42:31+02:00                                 Secret                    argocd         argocd-secret                          OutOfSync                       
2021-07-18T17:42:31+02:00                             ServiceAccount                argocd         argocd-server                          OutOfSync                       
2021-07-18T17:42:31+02:00   apps                      Deployment                    argocd     argocd-dex-server                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00   apps                      Deployment                    argocd         argocd-server                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io  RoleBinding                   argocd         argocd-server                          OutOfSync                       
2021-07-18T17:42:31+02:00                              ConfigMap                    argocd    argocd-gpg-keys-cm                          OutOfSync                       
2021-07-18T17:42:31+02:00                             ServiceAccount                argocd     argocd-dex-server                          OutOfSync                       
2021-07-18T17:42:31+02:00   apps                      StatefulSet                   argocd  argocd-application-controller                 OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io        Role                    argocd     argocd-dex-server                          OutOfSync                       
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io        Role                    argocd         argocd-server                          OutOfSync                       
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io  RoleBinding                   argocd          argocd-redis                          OutOfSync                       
2021-07-18T17:42:31+02:00                                Service                    argocd          argocd-redis                          OutOfSync  Healthy              
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io        Role                    argocd  argocd-application-controller                 OutOfSync                       
2021-07-18T17:42:31+02:00  rbac.authorization.k8s.io  RoleBinding                   argocd     argocd-dex-server                          OutOfSync                       
2021-07-18T17:42:31+02:00                              ConfigMap                    argocd        argocd-rbac-cm                          OutOfSync                       
2021-07-18T17:42:33+02:00          Namespace                            argocd    Synced                       
2021-07-18T17:42:33+02:00             Secret      argocd         argocd-secret    Synced                       
2021-07-18T17:42:33+02:00          ConfigMap      argocd  argocd-ssh-known-hosts-cm    Synced                       
2021-07-18T17:42:33+02:00          ConfigMap      argocd    argocd-gpg-keys-cm         Synced                       
2021-07-18T17:42:33+02:00          ConfigMap      argocd   argocd-tls-certs-cm         Synced                       
2021-07-18T17:42:33+02:00          ConfigMap      argocd        argocd-rbac-cm    Synced                       
2021-07-18T17:42:33+02:00          ConfigMap      argocd             argocd-cm    Synced                       
2021-07-18T17:42:34+02:00         ServiceAccount      argocd         argocd-server             Synced                       
2021-07-18T17:42:34+02:00         ServiceAccount      argocd     argocd-dex-server             Synced                       
2021-07-18T17:42:34+02:00         ServiceAccount      argocd  argocd-application-controller    Synced                       
2021-07-18T17:42:34+02:00         ServiceAccount      argocd          argocd-redis             Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io  ClusterRole              argocd-application-controller    Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io  ClusterRole                     argocd-server             Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io  ClusterRoleBinding              argocd-application-controller    Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io  ClusterRoleBinding                     argocd-server             Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io        Role      argocd          argocd-redis             Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io        Role      argocd  argocd-application-controller    Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io        Role      argocd     argocd-dex-server             Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io        Role      argocd         argocd-server             Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io  RoleBinding      argocd     argocd-dex-server             Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io  RoleBinding      argocd         argocd-server             Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io  RoleBinding      argocd  argocd-application-controller    Synced                       
2021-07-18T17:42:34+02:00  rbac.authorization.k8s.io  RoleBinding      argocd          argocd-redis             Synced                       
2021-07-18T17:42:34+02:00            Service      argocd     argocd-dex-server    Synced  Healthy              
2021-07-18T17:42:34+02:00            Service      argocd         argocd-server    Synced  Healthy              
2021-07-18T17:42:34+02:00            Service      argocd        argocd-metrics    Synced  Healthy              
2021-07-18T17:42:35+02:00            Service      argocd  argocd-server-metrics    Synced  Healthy              
2021-07-18T17:42:35+02:00            Service      argocd          argocd-redis     Synced  Healthy              
2021-07-18T17:42:35+02:00            Service      argocd    argocd-repo-server     Synced  Healthy              
2021-07-18T17:42:35+02:00   apps  Deployment      argocd     argocd-dex-server    Synced  Healthy                  
2021-07-18T17:42:35+02:00   apps  Deployment      argocd         argocd-server    Synced  Progressing              
2021-07-18T17:42:35+02:00   apps  Deployment      argocd          argocd-redis    Synced  Progressing              
2021-07-18T17:42:35+02:00   apps  Deployment      argocd    argocd-repo-server    Synced  Healthy                  
2021-07-18T17:42:35+02:00   apps  Deployment       argocd          argocd-redis             Synced  Healthy              
2021-07-18T17:42:35+02:00   apps  Deployment       argocd         argocd-server             Synced  Healthy              
2021-07-18T17:42:35+02:00   apps  StatefulSet      argocd  argocd-application-controller    Synced  Healthy              
2021-07-18T17:42:35+02:00  networking.k8s.io     Ingress      argocd  ingress-argocd-server    Synced  Healthy              
2021-07-18T17:42:35+02:00                             ServiceAccount                argocd  argocd-application-controller                   Synced                        serviceaccount/argocd-application-controller configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io        Role                    argocd     argocd-dex-server                            Synced                        role.rbac.authorization.k8s.io/argocd-dex-server reconciled. reconciliation required update. role.rbac.authorization.k8s.io/argocd-dex-server configured
2021-07-18T17:42:35+02:00   apps                      Deployment                    argocd    argocd-repo-server                            Synced   Healthy              deployment.apps/argocd-repo-server configured
2021-07-18T17:42:35+02:00   apps                      Deployment                    argocd         argocd-server                            Synced   Healthy              deployment.apps/argocd-server configured
2021-07-18T17:42:35+02:00   apps                      StatefulSet                   argocd  argocd-application-controller                   Synced   Healthy              statefulset.apps/argocd-application-controller configured
2021-07-18T17:42:35+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-dex-server-network-policy              OutOfSync                       networkpolicy.networking.k8s.io/argocd-dex-server-network-policy configured
2021-07-18T17:42:35+02:00                                 Secret                    argocd         argocd-secret                            Synced                        secret/argocd-secret configured
2021-07-18T17:42:35+02:00  apiextensions.k8s.io       CustomResourceDefinition      argocd  applications.argoproj.io                       Running    Synced              customresourcedefinition.apiextensions.k8s.io/applications.argoproj.io unchanged
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io  ClusterRole                   argocd         argocd-server                           Running    Synced              clusterrole.rbac.authorization.k8s.io/argocd-server reconciled. reconciliation required update. clusterrole.rbac.authorization.k8s.io/argocd-server configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io        Role                    argocd          argocd-redis                            Synced                        role.rbac.authorization.k8s.io/argocd-redis reconciled. reconciliation required update. role.rbac.authorization.k8s.io/argocd-redis configured
2021-07-18T17:42:35+02:00   apps                      Deployment                    argocd          argocd-redis                            Synced   Healthy              deployment.apps/argocd-redis configured
2021-07-18T17:42:35+02:00                                Service                    argocd     argocd-dex-server                            Synced   Healthy              service/argocd-dex-server configured
2021-07-18T17:42:35+02:00                                Service                    argocd        argocd-metrics                            Synced   Healthy              service/argocd-metrics configured
2021-07-18T17:42:35+02:00                                Service                    argocd  argocd-server-metrics                           Synced   Healthy              service/argocd-server-metrics configured
2021-07-18T17:42:35+02:00  networking.k8s.io             Ingress                    argocd  ingress-argocd-server                           Synced   Healthy              ingress.networking.k8s.io/ingress-argocd-server configured
2021-07-18T17:42:35+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-application-controller-network-policy  OutOfSync                       networkpolicy.networking.k8s.io/argocd-application-controller-network-policy configured
2021-07-18T17:42:35+02:00                              ConfigMap                    argocd        argocd-rbac-cm                            Synced                        configmap/argocd-rbac-cm configured
2021-07-18T17:42:35+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-repo-server-network-policy             OutOfSync                       networkpolicy.networking.k8s.io/argocd-repo-server-network-policy configured
2021-07-18T17:42:35+02:00                                Service                    argocd          argocd-redis                            Synced   Healthy              service/argocd-redis configured
2021-07-18T17:42:35+02:00  apiextensions.k8s.io       CustomResourceDefinition      argocd  appprojects.argoproj.io                        Running    Synced              customresourcedefinition.apiextensions.k8s.io/appprojects.argoproj.io unchanged
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io  ClusterRole                   argocd  argocd-application-controller                  Running    Synced              clusterrole.rbac.authorization.k8s.io/argocd-application-controller reconciled. reconciliation required update. clusterrole.rbac.authorization.k8s.io/argocd-application-controller configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io        Role                    argocd  argocd-application-controller                   Synced                        role.rbac.authorization.k8s.io/argocd-application-controller reconciled. reconciliation required update. role.rbac.authorization.k8s.io/argocd-application-controller configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io        Role                    argocd         argocd-server                            Synced                        role.rbac.authorization.k8s.io/argocd-server reconciled. reconciliation required update. role.rbac.authorization.k8s.io/argocd-server configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io  RoleBinding                   argocd     argocd-dex-server                            Synced                        rolebinding.rbac.authorization.k8s.io/argocd-dex-server reconciled. reconciliation required update. rolebinding.rbac.authorization.k8s.io/argocd-dex-server configured
2021-07-18T17:42:35+02:00                                Service                    argocd         argocd-server                            Synced   Healthy              service/argocd-server configured
2021-07-18T17:42:35+02:00                              Namespace                    argocd                argocd                           Running    Synced              namespace/argocd configured
2021-07-18T17:42:35+02:00                              ConfigMap                    argocd   argocd-tls-certs-cm                            Synced                        configmap/argocd-tls-certs-cm configured
2021-07-18T17:42:35+02:00                              ConfigMap                    argocd             argocd-cm                            Synced                        configmap/argocd-cm configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io  ClusterRoleBinding            argocd  argocd-application-controller                  Running    Synced              clusterrolebinding.rbac.authorization.k8s.io/argocd-application-controller reconciled. reconciliation required update. clusterrolebinding.rbac.authorization.k8s.io/argocd-application-controller configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io  RoleBinding                   argocd         argocd-server                            Synced                        rolebinding.rbac.authorization.k8s.io/argocd-server reconciled. reconciliation required update. rolebinding.rbac.authorization.k8s.io/argocd-server configured
2021-07-18T17:42:35+02:00                             ServiceAccount                argocd     argocd-dex-server                            Synced                        serviceaccount/argocd-dex-server configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io  ClusterRoleBinding            argocd         argocd-server                           Running    Synced              clusterrolebinding.rbac.authorization.k8s.io/argocd-server reconciled. reconciliation required update. clusterrolebinding.rbac.authorization.k8s.io/argocd-server configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io  RoleBinding                   argocd  argocd-application-controller                   Synced                        rolebinding.rbac.authorization.k8s.io/argocd-application-controller reconciled. reconciliation required update. rolebinding.rbac.authorization.k8s.io/argocd-application-controller configured
2021-07-18T17:42:35+02:00                                Service                    argocd    argocd-repo-server                            Synced   Healthy              service/argocd-repo-server configured
2021-07-18T17:42:35+02:00   apps                      Deployment                    argocd     argocd-dex-server                            Synced   Healthy              deployment.apps/argocd-dex-server configured
2021-07-18T17:42:35+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-redis-network-policy                   OutOfSync                       networkpolicy.networking.k8s.io/argocd-redis-network-policy configured
2021-07-18T17:42:35+02:00                              ConfigMap                    argocd  argocd-ssh-known-hosts-cm                       Synced                        configmap/argocd-ssh-known-hosts-cm configured
2021-07-18T17:42:35+02:00                              ConfigMap                    argocd    argocd-gpg-keys-cm                            Synced                        configmap/argocd-gpg-keys-cm configured
2021-07-18T17:42:35+02:00                             ServiceAccount                argocd         argocd-server                            Synced                        serviceaccount/argocd-server configured
2021-07-18T17:42:35+02:00                             ServiceAccount                argocd          argocd-redis                            Synced                        serviceaccount/argocd-redis configured
2021-07-18T17:42:35+02:00  rbac.authorization.k8s.io  RoleBinding                   argocd          argocd-redis                            Synced                        rolebinding.rbac.authorization.k8s.io/argocd-redis reconciled. reconciliation required update. rolebinding.rbac.authorization.k8s.io/argocd-redis configured
2021-07-18T17:42:35+02:00  networking.k8s.io          NetworkPolicy                 argocd  argocd-server-network-policy                  OutOfSync                       networkpolicy.networking.k8s.io/argocd-server-network-policy configured
2021-07-18T17:42:35+02:00  networking.k8s.io  NetworkPolicy      argocd  argocd-redis-network-policy    Synced                       networkpolicy.networking.k8s.io/argocd-redis-network-policy configured
2021-07-18T17:42:35+02:00  networking.k8s.io  NetworkPolicy      argocd  argocd-dex-server-network-policy                Synced                       networkpolicy.networking.k8s.io/argocd-dex-server-network-policy configured
2021-07-18T17:42:35+02:00  networking.k8s.io  NetworkPolicy      argocd  argocd-repo-server-network-policy               Synced                       networkpolicy.networking.k8s.io/argocd-repo-server-network-policy configured
2021-07-18T17:42:35+02:00  networking.k8s.io  NetworkPolicy      argocd  argocd-application-controller-network-policy    Synced                       networkpolicy.networking.k8s.io/argocd-application-controller-network-policy configured
2021-07-18T17:42:35+02:00  networking.k8s.io  NetworkPolicy      argocd  argocd-server-network-policy                    Synced                       networkpolicy.networking.k8s.io/argocd-server-network-policy configured

Name:               argocd
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          argocd
URL:                https://argocd.k3sdemo.lan/applications/argocd
Repo:               https://github.com/dgo19/k3s-demo.git
Target:             HEAD
Path:               argocd
SyncWindow:         Sync Allowed
Sync Policy:        <none>
Sync Status:        Synced to HEAD (edb5c9d)
Health Status:      Healthy

Operation:          Sync
Sync Revision:      edb5c9d53210ba7bcc398e9370dc47b0e3b0dd28
Phase:              Succeeded
Start:              2021-07-18 17:42:31 +0200 CEST
Finished:           2021-07-18 17:42:35 +0200 CEST
Duration:           4s
Message:            successfully synced (all tasks run)

GROUP                      KIND                      NAMESPACE  NAME                                          STATUS   HEALTH   HOOK  MESSAGE
                           Namespace                 argocd     argocd                                        Running  Synced         namespace/argocd configured
                           Secret                    argocd     argocd-secret                                 Synced                  secret/argocd-secret configured
                           ConfigMap                 argocd     argocd-ssh-known-hosts-cm                     Synced                  configmap/argocd-ssh-known-hosts-cm configured
                           ConfigMap                 argocd     argocd-gpg-keys-cm                            Synced                  configmap/argocd-gpg-keys-cm configured
                           ConfigMap                 argocd     argocd-rbac-cm                                Synced                  configmap/argocd-rbac-cm configured
                           ConfigMap                 argocd     argocd-tls-certs-cm                           Synced                  configmap/argocd-tls-certs-cm configured
                           ConfigMap                 argocd     argocd-cm                                     Synced                  configmap/argocd-cm configured
                           ServiceAccount            argocd     argocd-server                                 Synced                  serviceaccount/argocd-server configured
                           ServiceAccount            argocd     argocd-dex-server                             Synced                  serviceaccount/argocd-dex-server configured
                           ServiceAccount            argocd     argocd-application-controller                 Synced                  serviceaccount/argocd-application-controller configured
                           ServiceAccount            argocd     argocd-redis                                  Synced                  serviceaccount/argocd-redis configured
apiextensions.k8s.io       CustomResourceDefinition  argocd     appprojects.argoproj.io                       Running  Synced         customresourcedefinition.apiextensions.k8s.io/appprojects.argoproj.io unchanged
apiextensions.k8s.io       CustomResourceDefinition  argocd     applications.argoproj.io                      Running  Synced         customresourcedefinition.apiextensions.k8s.io/applications.argoproj.io unchanged
rbac.authorization.k8s.io  ClusterRole               argocd     argocd-server                                 Running  Synced         clusterrole.rbac.authorization.k8s.io/argocd-server reconciled. reconciliation required update. clusterrole.rbac.authorization.k8s.io/argocd-server configured
rbac.authorization.k8s.io  ClusterRole               argocd     argocd-application-controller                 Running  Synced         clusterrole.rbac.authorization.k8s.io/argocd-application-controller reconciled. reconciliation required update. clusterrole.rbac.authorization.k8s.io/argocd-application-controller configured
rbac.authorization.k8s.io  ClusterRoleBinding        argocd     argocd-application-controller                 Running  Synced         clusterrolebinding.rbac.authorization.k8s.io/argocd-application-controller reconciled. reconciliation required update. clusterrolebinding.rbac.authorization.k8s.io/argocd-application-controller configured
rbac.authorization.k8s.io  ClusterRoleBinding        argocd     argocd-server                                 Running  Synced         clusterrolebinding.rbac.authorization.k8s.io/argocd-server reconciled. reconciliation required update. clusterrolebinding.rbac.authorization.k8s.io/argocd-server configured
rbac.authorization.k8s.io  Role                      argocd     argocd-application-controller                 Synced                  role.rbac.authorization.k8s.io/argocd-application-controller reconciled. reconciliation required update. role.rbac.authorization.k8s.io/argocd-application-controller configured
rbac.authorization.k8s.io  Role                      argocd     argocd-dex-server                             Synced                  role.rbac.authorization.k8s.io/argocd-dex-server reconciled. reconciliation required update. role.rbac.authorization.k8s.io/argocd-dex-server configured
rbac.authorization.k8s.io  Role                      argocd     argocd-server                                 Synced                  role.rbac.authorization.k8s.io/argocd-server reconciled. reconciliation required update. role.rbac.authorization.k8s.io/argocd-server configured
rbac.authorization.k8s.io  Role                      argocd     argocd-redis                                  Synced                  role.rbac.authorization.k8s.io/argocd-redis reconciled. reconciliation required update. role.rbac.authorization.k8s.io/argocd-redis configured
rbac.authorization.k8s.io  RoleBinding               argocd     argocd-server                                 Synced                  rolebinding.rbac.authorization.k8s.io/argocd-server reconciled. reconciliation required update. rolebinding.rbac.authorization.k8s.io/argocd-server configured
rbac.authorization.k8s.io  RoleBinding               argocd     argocd-redis                                  Synced                  rolebinding.rbac.authorization.k8s.io/argocd-redis reconciled. reconciliation required update. rolebinding.rbac.authorization.k8s.io/argocd-redis configured
rbac.authorization.k8s.io  RoleBinding               argocd     argocd-dex-server                             Synced                  rolebinding.rbac.authorization.k8s.io/argocd-dex-server reconciled. reconciliation required update. rolebinding.rbac.authorization.k8s.io/argocd-dex-server configured
rbac.authorization.k8s.io  RoleBinding               argocd     argocd-application-controller                 Synced                  rolebinding.rbac.authorization.k8s.io/argocd-application-controller reconciled. reconciliation required update. rolebinding.rbac.authorization.k8s.io/argocd-application-controller configured
                           Service                   argocd     argocd-dex-server                             Synced   Healthy        service/argocd-dex-server configured
                           Service                   argocd     argocd-server                                 Synced   Healthy        service/argocd-server configured
                           Service                   argocd     argocd-metrics                                Synced   Healthy        service/argocd-metrics configured
                           Service                   argocd     argocd-server-metrics                         Synced   Healthy        service/argocd-server-metrics configured
                           Service                   argocd     argocd-repo-server                            Synced   Healthy        service/argocd-repo-server configured
                           Service                   argocd     argocd-redis                                  Synced   Healthy        service/argocd-redis configured
apps                       Deployment                argocd     argocd-dex-server                             Synced   Healthy        deployment.apps/argocd-dex-server configured
apps                       Deployment                argocd     argocd-redis                                  Synced   Healthy        deployment.apps/argocd-redis configured
apps                       Deployment                argocd     argocd-repo-server                            Synced   Healthy        deployment.apps/argocd-repo-server configured
apps                       Deployment                argocd     argocd-server                                 Synced   Healthy        deployment.apps/argocd-server configured
apps                       StatefulSet               argocd     argocd-application-controller                 Synced   Healthy        statefulset.apps/argocd-application-controller configured
networking.k8s.io          Ingress                   argocd     ingress-argocd-server                         Synced   Healthy        ingress.networking.k8s.io/ingress-argocd-server configured
networking.k8s.io          NetworkPolicy             argocd     argocd-redis-network-policy                   Synced                  networkpolicy.networking.k8s.io/argocd-redis-network-policy configured
networking.k8s.io          NetworkPolicy             argocd     argocd-dex-server-network-policy              Synced                  networkpolicy.networking.k8s.io/argocd-dex-server-network-policy configured
networking.k8s.io          NetworkPolicy             argocd     argocd-server-network-policy                  Synced                  networkpolicy.networking.k8s.io/argocd-server-network-policy configured
networking.k8s.io          NetworkPolicy             argocd     argocd-repo-server-network-policy             Synced                  networkpolicy.networking.k8s.io/argocd-repo-server-network-policy configured
networking.k8s.io          NetworkPolicy             argocd     argocd-application-controller-network-policy  Synced                  networkpolicy.networking.k8s.io/argocd-application-controller-network-policy configured
                           Namespace                            argocd                                        Synced                  
apiextensions.k8s.io       CustomResourceDefinition             applications.argoproj.io                      Synced                  
apiextensions.k8s.io       CustomResourceDefinition             appprojects.argoproj.io                       Synced                  
rbac.authorization.k8s.io  ClusterRole                          argocd-application-controller                 Synced                  
rbac.authorization.k8s.io  ClusterRole                          argocd-server                                 Synced                  
rbac.authorization.k8s.io  ClusterRoleBinding                   argocd-application-controller                 Synced                  
rbac.authorization.k8s.io  ClusterRoleBinding                   argocd-server                                 Synced                  
```
```
$ argocd app list
NAME    CLUSTER                         NAMESPACE  PROJECT  STATUS  HEALTH   SYNCPOLICY  CONDITIONS  REPO                                   PATH    TARGET
argocd  https://kubernetes.default.svc  argocd     default  Synced  Healthy  <none>      <none>      https://github.com/dgo19/k3s-demo.git  argocd  HEAD
```


