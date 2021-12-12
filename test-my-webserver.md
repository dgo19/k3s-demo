# k3s-demo walkthrough - my-webserver

Create namespace and deployment for nginx
``` 
$ kubectl create namespace test
namespace/test created
$ kubectl get namespace
NAME              STATUS   AGE
default           Active   54m
kube-system       Active   54m
kube-public       Active   54m
kube-node-lease   Active   54m
ingress-nginx     Active   7m15s
test              Active   9s
$ kubectl -n test create deployment my-webserver --image=nginx
deployment.apps/my-webserver created
$ kubectl -n test get all
NAME                                READY   STATUS    RESTARTS   AGE
pod/my-webserver-59bbf47d46-7lth5   1/1     Running   0          16s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/my-webserver   1/1     1            1           16s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/my-webserver-59bbf47d46   1         1         1       16s
``` 
Access the new pod
``` 
$ kubectl -n test get pods -o wide
NAME                            READY   STATUS    RESTARTS   AGE    IP           NODE             NOMINATED NODE   READINESS GATES
my-webserver-59bbf47d46-7lth5   1/1     Running   0          115s   10.42.0.10   dgo-virtualbox   <none>           <none>
$ ping -c4 10.42.0.10
PING 10.42.0.10 (10.42.0.10) 56(84) bytes of data.
64 bytes from 10.42.0.10: icmp_seq=1 ttl=64 time=0.067 ms
64 bytes from 10.42.0.10: icmp_seq=2 ttl=64 time=0.036 ms
64 bytes from 10.42.0.10: icmp_seq=3 ttl=64 time=0.032 ms
64 bytes from 10.42.0.10: icmp_seq=4 ttl=64 time=0.029 ms

--- 10.42.0.10 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3062ms
rtt min/avg/max/mdev = 0.029/0.041/0.067/0.015 ms
$ curl -vvv http://10.42.0.10
*   Trying 10.42.0.10:80...
* Connected to 10.42.0.10 (10.42.0.10) port 80 (#0)
> GET / HTTP/1.1
> Host: 10.42.0.10
> User-Agent: curl/7.74.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.21.1
< Date: Sun, 18 Jul 2021 14:46:21 GMT
< Content-Type: text/html
< Content-Length: 612
< Last-Modified: Tue, 06 Jul 2021 14:59:17 GMT
< Connection: keep-alive
< ETag: "60e46fc5-264"
< Accept-Ranges: bytes
< 
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
* Connection #0 to host 10.42.0.10 left intact
``` 
Inspect the pod logs
``` 
$ kubectl -n test get pods
NAME                            READY   STATUS    RESTARTS   AGE
my-webserver-59bbf47d46-7lth5   1/1     Running   0          4m1s
$ kubectl -n test logs my-webserver-59bbf47d46-7lth5
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2021/07/18 14:44:01 [notice] 1#1: using the "epoll" event method
2021/07/18 14:44:01 [notice] 1#1: nginx/1.21.1
2021/07/18 14:44:01 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6) 
2021/07/18 14:44:01 [notice] 1#1: OS: Linux 5.11.0-22-generic
2021/07/18 14:44:01 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2021/07/18 14:44:01 [notice] 1#1: start worker processes
2021/07/18 14:44:01 [notice] 1#1: start worker process 31
2021/07/18 14:44:01 [notice] 1#1: start worker process 32
2021/07/18 14:44:01 [notice] 1#1: start worker process 33
2021/07/18 14:44:01 [notice] 1#1: start worker process 34
2021/07/18 14:44:01 [notice] 1#1: start worker process 35
2021/07/18 14:44:01 [notice] 1#1: start worker process 36
10.42.0.1 - - [18/Jul/2021:14:46:21 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
``` 
Delete the pod - it will be restarted by kubernetes
``` 
dgo@dgo-VirtualBox:~/k3s-demo/applications$ kubectl -n test get pods
NAME                            READY   STATUS    RESTARTS   AGE
my-webserver-59bbf47d46-7lth5   1/1     Running   0          5m38s
$ kubectl -n test delete pod my-webserver-59bbf47d46-7lth5
pod "my-webserver-59bbf47d46-7lth5" deleted
$ kubectl -n test get pods
NAME                            READY   STATUS    RESTARTS   AGE
my-webserver-59bbf47d46-g6pf4   1/1     Running   0          11s
$ kubectl -n test logs my-webserver-59bbf47d46-g6pf4
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2021/07/18 14:49:54 [notice] 1#1: using the "epoll" event method
2021/07/18 14:49:54 [notice] 1#1: nginx/1.21.1
2021/07/18 14:49:54 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6) 
2021/07/18 14:49:54 [notice] 1#1: OS: Linux 5.11.0-22-generic
2021/07/18 14:49:54 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2021/07/18 14:49:54 [notice] 1#1: start worker processes
2021/07/18 14:49:54 [notice] 1#1: start worker process 31
2021/07/18 14:49:54 [notice] 1#1: start worker process 32
2021/07/18 14:49:54 [notice] 1#1: start worker process 33
2021/07/18 14:49:54 [notice] 1#1: start worker process 34
2021/07/18 14:49:54 [notice] 1#1: start worker process 35
2021/07/18 14:49:54 [notice] 1#1: start worker process 36
``` 
Scale the pod and increase the replicas to 2.
``` 
$ kubectl -n test scale deployment --replicas=2 my-webserver
deployment.apps/my-webserver scaled
$ kubectl -n test get deployment
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
my-webserver   2/2     2            2           8m37s
$ kubectl -n test get replicaset
NAME                      DESIRED   CURRENT   READY   AGE
my-webserver-59bbf47d46   2         2         2       8m44s
$ kubectl -n test get pods -o wide
NAME                            READY   STATUS    RESTARTS   AGE     IP           NODE             NOMINATED NODE   READINESS GATES
my-webserver-59bbf47d46-g6pf4   1/1     Running   0          2m51s   10.42.0.11   dgo-virtualbox   <none>           <none>
my-webserver-59bbf47d46-zbtrd   1/1     Running   0          24s     10.42.0.12   dgo-virtualbox   <none>           <none>
$ curl http://10.42.0.11 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
$ curl http://10.42.0.12 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
``` 
Create service for my-webserver.
``` 
$ kubectl -n test create service clusterip my-webserver --tcp=80:80
service/my-webserver created
$ kubectl -n test get svc
NAME           TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
my-webserver   ClusterIP   10.43.58.86   <none>        80/TCP    10s
$ kubectl -n test describe svc my-webserver 
Name:              my-webserver
Namespace:         test
Labels:            app=my-webserver
Annotations:       <none>
Selector:          app=my-webserver
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.43.58.86
IPs:               10.43.58.86
Port:              80-80  80/TCP
TargetPort:        80/TCP
Endpoints:         10.42.0.11:80,10.42.0.12:80
Session Affinity:  None
Events:            <none>
$ curl http://10.43.58.86 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
$ curl http://10.43.58.86 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
$ curl http://10.43.58.86 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
$ curl http://10.43.58.86 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
$ curl http://10.43.58.86 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
$ kubectl -n test logs my-webserver-59bbf47d46-
my-webserver-59bbf47d46-g6pf4  my-webserver-59bbf47d46-zbtrd  
$ kubectl -n test logs my-webserver-59bbf47d46-g6pf4 
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2021/07/18 14:49:54 [notice] 1#1: using the "epoll" event method
2021/07/18 14:49:54 [notice] 1#1: nginx/1.21.1
2021/07/18 14:49:54 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6) 
2021/07/18 14:49:54 [notice] 1#1: OS: Linux 5.11.0-22-generic
2021/07/18 14:49:54 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2021/07/18 14:49:54 [notice] 1#1: start worker processes
2021/07/18 14:49:54 [notice] 1#1: start worker process 31
2021/07/18 14:49:54 [notice] 1#1: start worker process 32
2021/07/18 14:49:54 [notice] 1#1: start worker process 33
2021/07/18 14:49:54 [notice] 1#1: start worker process 34
2021/07/18 14:49:54 [notice] 1#1: start worker process 35
2021/07/18 14:49:54 [notice] 1#1: start worker process 36
10.42.0.1 - - [18/Jul/2021:14:53:03 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
10.42.0.1 - - [18/Jul/2021:14:55:59 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
10.42.0.1 - - [18/Jul/2021:14:56:00 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
10.42.0.1 - - [18/Jul/2021:14:56:01 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
10.42.0.1 - - [18/Jul/2021:14:56:02 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
10.42.0.1 - - [18/Jul/2021:14:56:02 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
$ kubectl -n test logs my-webserver-59bbf47d46-zbtrd 
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2021/07/18 14:52:21 [notice] 1#1: using the "epoll" event method
2021/07/18 14:52:21 [notice] 1#1: nginx/1.21.1
2021/07/18 14:52:21 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6) 
2021/07/18 14:52:21 [notice] 1#1: OS: Linux 5.11.0-22-generic
2021/07/18 14:52:21 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2021/07/18 14:52:21 [notice] 1#1: start worker processes
2021/07/18 14:52:21 [notice] 1#1: start worker process 32
2021/07/18 14:52:21 [notice] 1#1: start worker process 33
2021/07/18 14:52:21 [notice] 1#1: start worker process 34
2021/07/18 14:52:21 [notice] 1#1: start worker process 35
2021/07/18 14:52:21 [notice] 1#1: start worker process 36
2021/07/18 14:52:21 [notice] 1#1: start worker process 37
10.42.0.1 - - [18/Jul/2021:14:53:09 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
10.42.0.1 - - [18/Jul/2021:14:57:16 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.74.0" "-"
``` 
Create and test ingress.
``` 
$ cat <<EOF | kubectl -n test apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-my-webserver
spec:
  rules:
  - host: my-webserver.k3sdemo.lan
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-webserver
            port:
              number: 80
EOF
ingress.extensions/ingress-my-webserver created
``` 
``` 
$ curl -v --header "Host: my-webserver.k3sdemo.lan" http://localhost
*   Trying 127.0.0.1:80...
* Connected to localhost (127.0.0.1) port 80 (#0)
> GET / HTTP/1.1
> Host: my-webserver.k3sdemo.lan
> User-Agent: curl/7.74.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Sun, 18 Jul 2021 15:01:32 GMT
< Content-Type: text/html
< Content-Length: 612
< Connection: keep-alive
< Last-Modified: Tue, 06 Jul 2021 14:59:17 GMT
< ETag: "60e46fc5-264"
< Accept-Ranges: bytes
< 
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
* Connection #0 to host localhost left intact
``` 
``` 
$ curl -kv --header "Host: my-webserver.k3sdemo.lan" https://localhost
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
* Using Stream ID: 1 (easy handle 0x55937c1b1580)
> GET / HTTP/2
> Host: my-webserver.k3sdemo.lan
> user-agent: curl/7.74.0
> accept: */*
> 
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
< HTTP/2 200 
< date: Sun, 18 Jul 2021 15:01:48 GMT
< content-type: text/html
< content-length: 612
< last-modified: Tue, 06 Jul 2021 14:59:17 GMT
< etag: "60e46fc5-264"
< accept-ranges: bytes
< strict-transport-security: max-age=15724800; includeSubDomains
< 
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
* Connection #0 to host localhost left intact
``` 
Delete the test namespace
``` 
$ kubectl delete namespace test
namespace "test" deleted
``` 
Create my-webserver by using kustomize build. Examples at applications/test-my-webserver
``` 
$ cd ~/k3s-demo/applications/test-my-webserver/
$ kustomize build . | kubectl apply -f -
namespace/test created
service/my-webserver created
deployment.apps/my-webserver created
ingress.networking.k8s.io/ingress-my-webserver created
$ kubectl -n test get pods
NAME                            READY   STATUS    RESTARTS   AGE
my-webserver-59bbf47d46-t2nh6   1/1     Running   0          10s
my-webserver-59bbf47d46-kb5bp   1/1     Running   0          10s
``` 
Create my-webserver by kubectl -k. Examples at applications/test-my-webserver
``` 
$ kubectl delete namespace test
namespace "test" deleted
$ kubectl apply -k .
namespace/test created
service/my-webserver created
deployment.apps/my-webserver created
ingress.extensions/ingress-my-webserver created
$ kubectl -n test get pods
NAME                            READY   STATUS    RESTARTS   AGE
my-webserver-59bbf47d46-6x7kn   1/1     Running   0          15s
my-webserver-59bbf47d46-zz7l2   1/1     Running   0          15s
``` 
