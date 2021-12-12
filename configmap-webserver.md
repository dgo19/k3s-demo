## Configmap - Webserver example
In case of a single ubuntu VM, add the required subdomain to /etc/hosts
```
$ sudo sed -i '/^127.0.0.1/ s/$/ configmap-web\.k3sdemo\.lan/' /etc/hosts
```
create namespace for configmap tests
```
$ kubectl create namespace configmaps
namespace/configmaps created
```
Create configmap with two variables and values.
```
$ kubectl -n configmaps create configmap nginx-env --from-literal=my-var1=test --from-literal=my-var2=two
configmap/nginx-env created
$ kubectl -n configmaps get configmaps nginx-env -o yaml
apiVersion: v1
data:
  my-var1: test
  my-var2: two
kind: ConfigMap
metadata:
  creationTimestamp: "2020-05-15T18:12:26Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:my-var1: {}
        f:my-var2: {}
    manager: kubectl
    operation: Update
    time: "2020-05-15T18:12:26Z"
  name: nginx-env
  namespace: configmaps
  resourceVersion: "160290"
  selfLink: /api/v1/namespaces/configmaps/configmaps/nginx-env
  uid: dfe825bb-fb9c-4cbf-9e9e-ff0da3166322
```
Download the index.html
```
$ curl -k https://my-webserver.k3s-demo.lan/ > index.html
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  14926      0 --:--:-- --:--:-- --:--:-- 14926
```
Edit the index html. We will exchange it by a configmap.
```
$ vi index.html
```
Create a configmap with the edited index.html.
```
$ kubectl -n configmaps create configmap nginx-index --from-file=index.html=index.html
configmap/nginx-index created
dgo@dgo-VirtualBox:~$ kubectl -n configmaps get configmap nginx-index -o yaml
apiVersion: v1
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <p><center>index.html from configmap</center></p>
    <hr>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
kind: ConfigMap
metadata:
  creationTimestamp: "2020-05-15T18:13:48Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:index.html: {}
    manager: kubectl
    operation: Update
    time: "2020-05-15T18:13:48Z"
  name: nginx-index
  namespace: configmaps
  resourceVersion: "160480"
  selfLink: /api/v1/namespaces/configmaps/configmaps/nginx-index
  uid: 92daa345-be2d-4514-b4fa-09b3a8c89be9
```
A configmap can contain literals and files.
```
$ kubectl -n configmaps create configmap nginx --from-file=index.html=index.html --from-literal=my-var1=test --from-literal=my-var2=two 
configmap/nginx created
$ kubectl -n configmaps get configmaps nginx -o yaml
apiVersion: v1
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <p><center>index.html from configmap</center></p>
    <hr>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
  my-var1: test
  my-var2: two
kind: ConfigMap
metadata:
  creationTimestamp: "2020-05-15T18:15:01Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:index.html: {}
        f:my-var1: {}
        f:my-var2: {}
    manager: kubectl
    operation: Update
    time: "2020-05-15T18:15:01Z"
  name: nginx
  namespace: configmaps
  resourceVersion: "160657"
  selfLink: /api/v1/namespaces/configmaps/configmaps/nginx
  uid: c763e09d-b974-4172-aed8-f3f6a8be5a7b
```
Delete the configmaps.
```
$ kubectl -n configmaps delete configmaps nginx-env 
configmap "nginx-env" deleted
$ kubectl -n configmaps delete configmaps nginx-index 
configmap "nginx-index" deleted
$ kubectl -n configmaps delete configmaps nginx
configmap "nginx" deleted
```
Create a configmap by a yaml-file.
```
$ cat <<EOF | kubectl -n configmaps apply -f -
apiVersion: v1
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <p><center>index.html from configmap</center></p>
    <hr>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
  my-var1: test
  my-var2: two
kind: ConfigMap
metadata:
  name: nginx
EOF
```
Clean up and delete the namespace configmaps.
```
$ kubectl delete namespace configmaps 
namespace "configmaps" deleted
```
Review the contents of the directory k3s-demo/applications/configmaps/
The configMapGenerator of kustomize will be used to create the configmap.
```
$ cd ~/k3s-demo/applications/configmaps/
$ ls -l index.html 
-rw-rw-r-- 1 dgo dgo 667 Mai 15 16:13 index.html
$ cat kustomization.yaml 
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: configmaps

resources:
  - deployment-configmap-web.yaml
  - ingress-configmap-web.yaml
  - namespace-configmaps.yaml
  - service-configmap-web.yaml

configMapGenerator:
  - name: nginx
    literals:
      - my-var1=test
      - my-var2=two
    files:
      - index.html=index.html

generatorOptions:
  disableNameSuffixHash: true
```
Review the output of kustomize build wth the new configmap.
The deployment contains a volume mount for the index.html and it imports the variables from the configmap.
```
$ kustomize build .
```
Create the ressources with kubectl apply -k . and review the results.
```
$ kubectl create -k .
namespace/configmaps created
configmap/nginx created
service/configmap-web created
deployment.apps/configmap-web created
ingress.extensions/ingress-configmap-web created
$ kubectl -n configmaps get pod
NAME                             READY   STATUS    RESTARTS   AGE
configmap-web-7f74946c78-mmg44   1/1     Running   0          15s
$ kubectl -n configmaps exec configmap-web-7f74946c78-mmg44 -- env | grep VARIABLE
VARIABLE1=test
VARIABLE2=two
$ curl -k https://configmap-web.k3s-demo.lan
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<p><center>index.html from configmap</center></p>
<hr>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

