## Installation of k3s
```
$ curl -sfL https://get.k3s.io | sudo INSTALL_K3S_EXEC="server --disable traefik" sh -
[INFO]  Finding release for channel stable
[INFO]  Using v1.21.2+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.21.2+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.21.2+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s
```
Copy credentials for kubectl and set alias for kubectl
```
$ mkdir ~/.kube
$ sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
$ sudo chown ${ID} ~/.kube/config
$ echo "alias kubectl='k3s kubectl'" >> ~/.bashrc
$ echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
$ echo 'source <(k3s kubectl completion bash)' >> ~/.bashrc
```
Get kustomize
```
$ mkdir ~/bin
$ curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.2.0/kustomize_v4.2.0_linux_amd64.tar.gz | tar xvzC ~/bin -f -
```
Get Helm
```
$ curl -L https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz | tar xvzC ~/bin --strip-components 1 -f - linux-amd64/helm
```
Get kubeseal
```
$ curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-amd64 > ~/bin/kubeseal
$ chmod +x ~/bin/kubeseal
```
Re-enter user session.

## Wildcard DNS for ingress
Add wildcard DNS entry for ingress:
The wildcard domain *.k3sdemo.lan will be used in this walkthrough for ingress. Please add a the wilcard domain to your DNS server pointing to the IP of the k3s node.

Test the wildcard domain
```
$ ping -c1 hello-wildcard.k3sdemo.lan
PING hello-wildcard.k3sdemo.lan (192.168.0.133) 56(84) bytes of data.
64 bytes from dgo-VirtualBox (192.168.0.133): icmp_seq=1 ttl=64 time=0.022 ms

--- hello-wildcard.k3sdemo.lan ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.022/0.022/0.022/0.000 ms

$ ping -c1 hello-wildcard2.k3sdemo.lan
PING hello-wildcard2.k3sdemo.lan (192.168.0.133) 56(84) bytes of data.
64 bytes from dgo-VirtualBox (192.168.0.133): icmp_seq=1 ttl=64 time=0.021 ms

--- hello-wildcard2.k3sdemo.lan ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.021/0.021/0.021/0.000 ms
```
In case of a single ubuntu VM, you add the required subdomains to /etc/hosts
```
sudo sed -i '/^127.0.0.1/ s/$/ my-webserver\.k3sdemo\.lan/' /etc/hosts
```
## Clone git Repo
```
$ git clone https://github.com/dgo19/k3s-demo.git
```
## Installation of sealed-secrets
```
$ cd k3s-demo/applications/sealed-secrets
$ kubectl create namespace sealed-secrets
namespace/sealed-secrets created
$ kubectl -n sealed-secrets create secret tls sealed-secrets-key --cert=sealed-secrets.crt --key=sealed-secrets.key
secret/sealed-secrets-key created
$ kubectl -n sealed-secrets label secret sealed-secrets-key sealedsecrets.bitnami.com/sealed-secrets-key=active
secret/sealed-secrets-key labeled
$ kubectl -n sealed-secrets get secrets --show-labels
NAME                  TYPE                                  DATA   AGE   LABELS
default-token-66t9s   kubernetes.io/service-account-token   3      23s   <none>
sealed-secrets-key    kubernetes.io/tls                     2      14s   sealedsecrets.bitnami.com/sealed-secrets-key=active
$ kubectl apply -k .
customresourcedefinition.apiextensions.k8s.io/sealedsecrets.bitnami.com unchanged
serviceaccount/sealed-secrets-controller created
Warning: rbac.authorization.k8s.io/v1beta1 Role is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 Role
role.rbac.authorization.k8s.io/sealed-secrets-key-admin created
role.rbac.authorization.k8s.io/sealed-secrets-service-proxier created
Warning: rbac.authorization.k8s.io/v1beta1 ClusterRole is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRole
clusterrole.rbac.authorization.k8s.io/secrets-unsealer created
Warning: rbac.authorization.k8s.io/v1beta1 RoleBinding is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 RoleBinding
rolebinding.rbac.authorization.k8s.io/sealed-secrets-controller created
rolebinding.rbac.authorization.k8s.io/sealed-secrets-service-proxier created
Warning: rbac.authorization.k8s.io/v1beta1 ClusterRoleBinding is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRoleBinding
clusterrolebinding.rbac.authorization.k8s.io/sealed-secrets-controller created
service/sealed-secrets-controller created
deployment.apps/sealed-secrets-controller created
```
## Installation of ingress nginx
Trust Ingress Certificate
```
$ cd k3s-demo/applications/ingress-nginx
$ sudo cp tls.crt /usr/local/share/ca-certificates/k3sdemo.lan.crt
$ sudo update-ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
```
Install ingress nginx
```
$ kubectl apply -k .
namespace/ingress-nginx created
serviceaccount/ingress-nginx created
serviceaccount/ingress-nginx-admission created
role.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
configmap/ingress-nginx-controller created
sealedsecret/tls-secret created
service/ingress-nginx-controller created
service/ingress-nginx-controller-admission created
deployment.apps/ingress-nginx-controller created
job.batch/ingress-nginx-admission-create created
job.batch/ingress-nginx-admission-patch created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created

$ kubectl -n ingress-nginx get pods
NAME                                       READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-mjf8k       0/1     Completed   0          86s
ingress-nginx-admission-patch-gdfq8        0/1     Completed   0          86s
ingress-nginx-controller-754c9d47b-t48wm   1/1     Running     0          86s

$ kubectl -n ingress-nginx get deployment
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
ingress-nginx-controller   1/1     1            1           111s

$ kubectl -n ingress-nginx get replicaset
NAME                                 DESIRED   CURRENT   READY   AGE
ingress-nginx-controller-754c9d47b   1         1         1       115s

$ kubectl -n ingress-nginx get pods -o wide
NAME                                       READY   STATUS      RESTARTS   AGE    IP              NODE             NOMINATED NODE   READINESS GATES
ingress-nginx-admission-create-mjf8k       0/1     Completed   0          2m4s   10.42.0.9       dgo-virtualbox   <none>           <none>
ingress-nginx-admission-patch-gdfq8        0/1     Completed   0          2m4s   10.42.0.8       dgo-virtualbox   <none>           <none>
ingress-nginx-controller-754c9d47b-t48wm   1/1     Running     0          2m4s   192.168.0.133   dgo-virtualbox   <none>           <none>
```
```
$ curl -v http://localhost
*   Trying 127.0.0.1:80...
* Connected to localhost (127.0.0.1) port 80 (#0)
> GET / HTTP/1.1
> Host: localhost
> User-Agent: curl/7.74.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 404 Not Found
< Date: Sun, 18 Jul 2021 14:39:21 GMT
< Content-Type: text/html
< Content-Length: 146
< Connection: keep-alive
< 
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host localhost left intact
```
```
$ curl -kv https://localhost
*   Trying 127.0.0.1:443...
* Connected to localhost (127.0.0.1) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: C=US; ST=VA; L=SomeCity; O=MyCompany; OU=MyDivision; CN=*.k3sdemo.lan
*  start date: Jul 18 14:34:03 2021 GMT
*  expire date: Jul 16 14:34:03 2031 GMT
*  issuer: C=US; ST=VA; L=SomeCity; O=MyCompany; OU=MyDivision; CN=*.k3sdemo.lan
*  SSL certificate verify result: self signed certificate (18), continuing anyway.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x5643ac0ce580)
> GET / HTTP/2
> Host: localhost
> user-agent: curl/7.74.0
> accept: */*
> 
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
< HTTP/2 404 
< date: Sun, 18 Jul 2021 14:39:42 GMT
< content-type: text/html
< content-length: 146
< strict-transport-security: max-age=15724800; includeSubDomains
< 
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host localhost left intact
```
## Installation of kube-prometheus-stack for monitoring
```
$ cd k3s-demo/applications/monitoring
$ helm install --dependency-update monitoring . -n monitoring --create-namespace
W0718 20:04:32.742398  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:32.743791  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:32.744975  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:32.746212  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:32.747503  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:32.748662  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:32.749832  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:32.999991  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:33.100576  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:34.668566  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:34.706017  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:34.706484  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:34.706644  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:34.707124  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:34.708312  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:34.708953  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:34.709917  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:36.433685  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:36.590896  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0718 20:04:44.871114  219497 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
NAME: monitoring
LAST DEPLOYED: Sun Jul 18 20:04:31 2021
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
```
```
$ kubectl -n monitoring get pods
NAME                                                     READY   STATUS    RESTARTS   AGE
monitoring-kube-prometheus-operator-656bdb8465-92hbb     1/1     Running   0          4m59s
monitoring-prometheus-node-exporter-zsddb                1/1     Running   0          4m59s
monitoring-grafana-685d8776c7-5qhzv                      2/2     Running   0          4m59s
alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   0          4m58s
prometheus-monitoring-kube-prometheus-prometheus-0       2/2     Running   1          4m58s
monitoring-kube-state-metrics-85d69795b9-4x9s6           1/1     Running   0          4m59s
```
