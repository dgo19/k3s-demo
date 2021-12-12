# Argo CD - Applications
Deploy root application:
```
$ cd ~/k3s-demo/applications/
$ kubectl apply -f applications.yaml
application.argoproj.io/applications created
```
Review diff and sync applications.
```
$ argocd app list
NAME          CLUSTER                         NAMESPACE  PROJECT  STATUS     HEALTH   SYNCPOLICY  CONDITIONS  REPO                                   PATH          TARGET
applications  https://kubernetes.default.svc  argocd     default  OutOfSync  Missing  <none>      <none>      https://github.com/dgo19/k3s-demo.git  applications  HEAD
argocd        https://kubernetes.default.svc  argocd     default  Synced     Healthy  <none>      <none>      https://github.com/dgo19/k3s-demo.git  argocd        HEAD
```
```
$ argocd app diff applications
===== argoproj.io/Application argocd/configmaps ======
0a1,17
> apiVersion: argoproj.io/v1alpha1
> kind: Application
> metadata:
>   labels:
>     app.kubernetes.io/instance: applications
>   name: configmaps
>   namespace: argocd
> spec:
>   destination:
>     namespace: configmaps
>     server: https://kubernetes.default.svc
>   project: default
>   source:
>     path: applications/configmaps
>     repoURL: https://github.com/dgo19/k3s-demo.git
>     targetRevision: HEAD
>   syncPolicy: {}
===== argoproj.io/Application argocd/ingress-nginx ======
0a1,17
> apiVersion: argoproj.io/v1alpha1
> kind: Application
> metadata:
>   labels:
>     app.kubernetes.io/instance: applications
>   name: ingress-nginx
>   namespace: argocd
> spec:
>   destination:
>     namespace: ingress-nginx
>     server: https://kubernetes.default.svc
>   project: default
>   source:
>     path: applications/ingress-nginx
>     repoURL: https://github.com/dgo19/k3s-demo.git
>     targetRevision: HEAD
>   syncPolicy: {}
===== argoproj.io/Application argocd/mariadb-ephemeral ======
0a1,17
> apiVersion: argoproj.io/v1alpha1
> kind: Application
> metadata:
>   labels:
>     app.kubernetes.io/instance: applications
>   name: mariadb-ephemeral
>   namespace: argocd
 ... output omitted ...
```
```
$ argocd app sync applications
TIMESTAMP                  GROUP              KIND    NAMESPACE                  NAME    STATUS    HEALTH        HOOK  MESSAGE
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     test-my-webserver  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            configmaps  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd         ingress-nginx  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     mariadb-ephemeral  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            mariadb-pv  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     postgres-operator  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd         ingress-nginx    Synced  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            mariadb-pv    Synced  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     test-my-webserver    Synced  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            configmaps  OutOfSync  Missing              application.argoproj.io/configmaps created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     mariadb-ephemeral  OutOfSync  Missing              application.argoproj.io/mariadb-ephemeral created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     test-my-webserver    Synced   Missing              application.argoproj.io/test-my-webserver created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd         ingress-nginx    Synced   Missing              application.argoproj.io/ingress-nginx created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            mariadb-pv    Synced   Missing              application.argoproj.io/mariadb-pv created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     postgres-operator  OutOfSync  Missing              application.argoproj.io/postgres-operator created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     postgres-operator    Synced  Missing              application.argoproj.io/postgres-operator created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            configmaps    Synced  Missing              application.argoproj.io/configmaps created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     mariadb-ephemeral    Synced  Missing              application.argoproj.io/mariadb-ephemeral created

Name:               applications
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          argocd
URL:                https://argocd.k3sdemo.lan/applications/applications
Repo:               https://github.com/dgo19/k3s-demo.git
Target:             HEAD
Path:               applications
SyncWindow:         Sync Allowed
Sync Policy:        <none>
Sync Status:        Synced to HEAD (371d4b5)
Health Status:      Healthy

Operation:          Sync
Sync Revision:      371d4b5a97aba1876b47e4a7777493596857ccfb
Phase:              Succeeded
Start:              2021-07-18 18:07:59 +0200 CEST
Finished:           2021-07-18 18:07:59 +0200 CEST
Duration:           0s
Message:            successfully synced (all tasks run)

GROUP        KIND         NAMESPACE  NAME               STATUS  HEALTH  HOOK  MESSAGE
argoproj.io  Application  argocd     test-my-webserver  Synced                application.argoproj.io/test-my-webserver created
argoproj.io  Application  argocd     ingress-nginx      Synced                application.argoproj.io/ingress-nginx created
argoproj.io  Application  argocd     mariadb-pv         Synced                application.argoproj.io/mariadb-pv created
argoproj.io  Application  argocd     postgres-operator  Synced                application.argoproj.io/postgres-operator created
argoproj.io  Application  argocd     configmaps         Synced                application.argoproj.io/configmaps created
argoproj.io  Application  argocd     mariadb-ephemeral  Synced                application.argoproj.io/mariadb-ephemeral created
```
View the list of applications.
```
$ argocd app list
TIMESTAMP                  GROUP              KIND    NAMESPACE                  NAME    STATUS    HEALTH        HOOK  MESSAGE
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     test-my-webserver  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            configmaps  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd         ingress-nginx  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     mariadb-ephemeral  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            mariadb-pv  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     postgres-operator  OutOfSync  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd         ingress-nginx    Synced  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            mariadb-pv    Synced  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     test-my-webserver    Synced  Missing              
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            configmaps  OutOfSync  Missing              application.argoproj.io/configmaps created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     mariadb-ephemeral  OutOfSync  Missing              application.argoproj.io/mariadb-ephemeral created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     test-my-webserver    Synced   Missing              application.argoproj.io/test-my-webserver created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd         ingress-nginx    Synced   Missing              application.argoproj.io/ingress-nginx created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            mariadb-pv    Synced   Missing              application.argoproj.io/mariadb-pv created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     postgres-operator  OutOfSync  Missing              application.argoproj.io/postgres-operator created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     postgres-operator    Synced  Missing              application.argoproj.io/postgres-operator created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd            configmaps    Synced  Missing              application.argoproj.io/configmaps created
2021-07-18T18:07:59+02:00  argoproj.io  Application      argocd     mariadb-ephemeral    Synced  Missing              application.argoproj.io/mariadb-ephemeral created

Name:               applications
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          argocd
URL:                https://argocd.k3sdemo.lan/applications/applications
Repo:               https://github.com/dgo19/k3s-demo.git
Target:             HEAD
Path:               applications
SyncWindow:         Sync Allowed
Sync Policy:        <none>
Sync Status:        Synced to HEAD (371d4b5)
Health Status:      Healthy

Operation:          Sync
Sync Revision:      371d4b5a97aba1876b47e4a7777493596857ccfb
Phase:              Succeeded
Start:              2021-07-18 18:07:59 +0200 CEST
Finished:           2021-07-18 18:07:59 +0200 CEST
Duration:           0s
Message:            successfully synced (all tasks run)

GROUP        KIND         NAMESPACE  NAME               STATUS  HEALTH  HOOK  MESSAGE
argoproj.io  Application  argocd     test-my-webserver  Synced                application.argoproj.io/test-my-webserver created
argoproj.io  Application  argocd     ingress-nginx      Synced                application.argoproj.io/ingress-nginx created
argoproj.io  Application  argocd     mariadb-pv         Synced                application.argoproj.io/mariadb-pv created
argoproj.io  Application  argocd     postgres-operator  Synced                application.argoproj.io/postgres-operator created
argoproj.io  Application  argocd     configmaps         Synced                application.argoproj.io/configmaps created
argoproj.io  Application  argocd     mariadb-ephemeral  Synced                application.argoproj.io/mariadb-ephemeral created
```
