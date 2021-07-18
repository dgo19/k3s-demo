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
## Installation of ingress nginx
```
$ git clone https://github.com/dgo19/k3s-demo.git
$ cd k3s-demo/applications/ingress-nginx
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
secret/tls-secret created
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
