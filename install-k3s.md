## Install required packages (example for ubuntu and debian)
```
$ sudo apt -y install git sudo curl apache2-utils
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
sudo is already the newest version (1.9.5p2-3ubuntu2).
sudo set to manually installed.
The following additional packages will be installed:
  git-man libapr1 libaprutil1 liberror-perl
Suggested packages:
  git-daemon-run | git-daemon-sysvinit git-doc git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn
The following NEW packages will be installed:
  apache2-utils curl git git-man libapr1 libaprutil1 liberror-perl
0 upgraded, 7 newly installed, 0 to remove and 144 not upgraded.
Need to get 4.463 kB of archives.
After this operation, 21,8 MB of additional disk space will be used.
Get:1 http://de.archive.ubuntu.com/ubuntu impish/main amd64 libapr1 amd64 1.7.0-6ubuntu1 [107 kB]
Get:2 http://de.archive.ubuntu.com/ubuntu impish/main amd64 libaprutil1 amd64 1.6.1-5ubuntu2 [84,6 kB]
Get:3 http://de.archive.ubuntu.com/ubuntu impish-updates/main amd64 apache2-utils amd64 2.4.48-3.1ubuntu3.2 [88,9 kB]
Get:4 http://de.archive.ubuntu.com/ubuntu impish/main amd64 curl amd64 7.74.0-1.3ubuntu2 [179 kB]
Get:5 http://de.archive.ubuntu.com/ubuntu impish/main amd64 liberror-perl all 0.17029-1 [26,5 kB]
Get:6 http://de.archive.ubuntu.com/ubuntu impish/main amd64 git-man all 1:2.32.0-1ubuntu1 [941 kB]
Get:7 http://de.archive.ubuntu.com/ubuntu impish/main amd64 git amd64 1:2.32.0-1ubuntu1 [3.036 kB]
Fetched 4.463 kB in 1s (5.494 kB/s)
Selecting previously unselected package libapr1:amd64.
(Reading database ... 182898 files and directories currently installed.)
Preparing to unpack .../0-libapr1_1.7.0-6ubuntu1_amd64.deb ...
Unpacking libapr1:amd64 (1.7.0-6ubuntu1) ...
Selecting previously unselected package libaprutil1:amd64.
Preparing to unpack .../1-libaprutil1_1.6.1-5ubuntu2_amd64.deb ...
Unpacking libaprutil1:amd64 (1.6.1-5ubuntu2) ...
Selecting previously unselected package apache2-utils.
Preparing to unpack .../2-apache2-utils_2.4.48-3.1ubuntu3.2_amd64.deb ...
Unpacking apache2-utils (2.4.48-3.1ubuntu3.2) ...
Selecting previously unselected package curl.
Preparing to unpack .../3-curl_7.74.0-1.3ubuntu2_amd64.deb ...
Unpacking curl (7.74.0-1.3ubuntu2) ...
Selecting previously unselected package liberror-perl.
Preparing to unpack .../4-liberror-perl_0.17029-1_all.deb ...
Unpacking liberror-perl (0.17029-1) ...
Selecting previously unselected package git-man.
Preparing to unpack .../5-git-man_1%3a2.32.0-1ubuntu1_all.deb ...
Unpacking git-man (1:2.32.0-1ubuntu1) ...
Selecting previously unselected package git.
Preparing to unpack .../6-git_1%3a2.32.0-1ubuntu1_amd64.deb ...
Unpacking git (1:2.32.0-1ubuntu1) ...
Setting up libapr1:amd64 (1.7.0-6ubuntu1) ...
Setting up liberror-perl (0.17029-1) ...
Setting up git-man (1:2.32.0-1ubuntu1) ...
Setting up curl (7.74.0-1.3ubuntu2) ...
Setting up libaprutil1:amd64 (1.6.1-5ubuntu2) ...
Setting up git (1:2.32.0-1ubuntu1) ...
Setting up apache2-utils (2.4.48-3.1ubuntu3.2) ...
Processing triggers for man-db (2.9.4-2) ...
Processing triggers for libc-bin (2.34-0ubuntu3) ...
```
## Installation of k3s
We install a specific version of k3s. It has been tested for this demo. You can install the latest version by omitting the INSTALL_K3s_VERSION variable or choose a version.
```
$ curl -sfL https://get.k3s.io | sudo INSTALL_K3S_VERSION="v1.22.6+k3s1" INSTALL_K3S_EXEC="server --disable traefik" sh -
[INFO]  Using v1.22.6+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.22.6+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.22.6+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping installation of SELinux RPM
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
$ sudo chown ${UID} ~/.kube/config
$ echo "alias kubectl='k3s kubectl'" >> ~/.bashrc
$ echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
$ echo 'source <(k3s kubectl completion bash)' >> ~/.bashrc
$ source .bashrc
```
Get kustomize
```
$ mkdir ~/bin
$ source .profile
$ curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.2/kustomize_v4.5.2_linux_amd64.tar.gz | tar xvzC ~/bin -f -
 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   674  100   674    0     0   2717      0 --:--:-- --:--:-- --:--:--  2717
  0 4525k    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0kustomize
100 4525k  100 4525k    0     0  4467k      0  0:00:01  0:00:01 --:--:-- 10.3M
```
Get Helm
```
$ curl -L https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz | tar xvzC ~/bin --strip-components 1 -f - linux-amd64/helm
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0linux-amd64/helm
100 12.9M  100 12.9M    0     0  9923k      0  0:00:01  0:00:01 --:--:-- 9930k
```
Get kubeseal
```
$ curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.3/kubeseal-0.17.3-linux-amd64.tar.gz | tar xvzC ~/bin -f - kubeseal
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   671  100   671    0     0   9450      0 --:--:-- --:--:-- --:--:--  9319
kubeseal
100 14.6M  100 14.6M    0     0  7647k      0  0:00:01  0:00:01 --:--:-- 10.0M
```

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
$ sudo sed -i '/^127.0.0.1/ s/$/ my-webserver\.k3sdemo\.lan/' /etc/hosts
```
## setup sysctl fs.inotify.max_user_instances
Increase max_user_instances for fs.inotify
```
$ sudo bash -c "echo 'fs.inotify.max_user_instances = 8192' > /etc/sysctl.d/98-fs-inotify-max_user_instances.conf"
$ sudo systemctl restart systemd-sysctl.service
```
Check value for variable. It should be 8192 now.
```
$ cat /proc/sys/fs/inotify/max_user_instances
8192
```

## Clone git Repo
```
$ git clone https://github.com/dgo19/k3s-demo.git ~/k3s-demo
Cloning into '/home/dgo/k3s-demo'...
remote: Enumerating objects: 1134, done.
remote: Counting objects: 100% (1134/1134), done.
remote: Compressing objects: 100% (808/808), done.
remote: Total 1134 (delta 693), reused 753 (delta 314), pack-reused 0
Receiving objects: 100% (1134/1134), 193.97 KiB | 3.40 MiB/s, done.
Resolving deltas: 100% (693/693), done.
```
## Installation of sealed-secrets
Create the namespace for sealed-secrets, the secret for the sealed-secrets key and the needed label.
```
$ cd ~/k3s-demo/applications/sealed-secrets
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
```
Deploy sealed-secrets.
```
$ kubectl apply -k .
customresourcedefinition.apiextensions.k8s.io/sealedsecrets.bitnami.com created
serviceaccount/sealed-secrets-controller created
role.rbac.authorization.k8s.io/sealed-secrets-key-admin created
role.rbac.authorization.k8s.io/sealed-secrets-service-proxier created
clusterrole.rbac.authorization.k8s.io/secrets-unsealer created
rolebinding.rbac.authorization.k8s.io/sealed-secrets-controller created
rolebinding.rbac.authorization.k8s.io/sealed-secrets-service-proxier created
clusterrolebinding.rbac.authorization.k8s.io/sealed-secrets-controller created
service/sealed-secrets-controller created
deployment.apps/sealed-secrets-controller created
ingress.networking.k8s.io/sealed-secrets created
```
## Installation of kube-prometheus-stack for monitoring
```
$ cd ~/k3s-demo/applications/monitoring
$ helm install --dependency-update monitoring . -n monitoring --create-namespace
Getting updates for unmanaged Helm repositories...
...Successfully got an update from the "https://prometheus-community.github.io/helm-charts" chart repository
Saving 1 charts
Downloading kube-prometheus-stack from repo https://prometheus-community.github.io/helm-charts
Deleting outdated charts
NAME: monitoring
LAST DEPLOYED: Thu Feb 17 18:15:51 2022
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
```
Check for running pods. This can take a few minutes to complete.
```
$ kubectl -n monitoring get pods
NAME                                                     READY   STATUS    RESTARTS   AGE
monitoring-prometheus-node-exporter-2mc7z                1/1     Running   0          61s
monitoring-kube-prometheus-operator-b645ccdc5-8rxhn      1/1     Running   0          61s
monitoring-kube-state-metrics-6876c96df5-r66xz           1/1     Running   0          60s
alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   0          54s
prometheus-monitoring-kube-prometheus-prometheus-0       2/2     Running   0          54s
monitoring-grafana-59b4bd7697-hps5p                      3/3     Running   0          61s
```
## Installation of ingress nginx
Trust Ingress Certificate
```
$ cd ~/k3s-demo/applications/ingress-nginx
$ sudo cp tls.crt /usr/local/share/ca-certificates/k3sdemo.lan.crt
$ sudo update-ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
```
Install ingress nginx
```
$ helm template --dependency-update ingress-nginx . -n ingress-nginx --create-namespace | kubectl apply -f -
namespace/ingress-nginx created
serviceaccount/ingress-nginx created
configmap/ingress-nginx-controller created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
service/ingress-nginx-controller-metrics created
service/ingress-nginx-controller-admission created
service/ingress-nginx-controller created
daemonset.apps/ingress-nginx-controller created
ingressclass.networking.k8s.io/nginx created
sealedsecret.bitnami.com/tls-secret created
servicemonitor.monitoring.coreos.com/ingress-nginx-controller created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
serviceaccount/ingress-nginx-admission created
clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
role.rbac.authorization.k8s.io/ingress-nginx-admission created
rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
job.batch/ingress-nginx-admission-create created
job.batch/ingress-nginx-admission-patch created
```
Check for running pods. This can take a few minutes to complete.
```
$ kubectl -n ingress-nginx get pods
NAME                                      READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create--1-rwzjr   0/1     Completed   0          69s
ingress-nginx-admission-patch--1-h9rmk    0/1     Completed   1          69s
ingress-nginx-controller-5cd4h            1/1     Running     0          69s

$ kubectl -n ingress-nginx get daemonset
NAME                       DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
ingress-nginx-controller   1         1         1       1            1           kubernetes.io/os=linux   113s

$ kubectl -n ingress-nginx get pods -o wide
AME                                      READY   STATUS      RESTARTS   AGE    IP              NODE             NOMINATED NODE   READINESS GATES
ingress-nginx-admission-create--1-rwzjr   0/1     Completed   0          3m8s   10.42.0.18      dgo-virtualbox   <none>           <none>
ingress-nginx-admission-patch--1-h9rmk    0/1     Completed   1          3m8s   10.42.0.17      dgo-virtualbox   <none>           <none>
ingress-nginx-controller-5cd4h            1/1     Running     0          3m8s   192.168.0.133   dgo-virtualbox   <none>           <none>
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
< Date: Thu, 17 Feb 2022 17:22:48 GMT
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
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x55d6e77ac5c0)
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
< date: Thu, 17 Feb 2022 17:23:52 GMT
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
