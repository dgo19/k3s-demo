# ansible playbook (tested on ubuntu)
install required packages (ubuntu/debian)
```
$ sudo apt -y install git sudo curl ansible
```
install required packages (fedora)
```
$ sudo yum -y install git sudo curl perl-Apache-Htpasswd ansible
```
clone git repository
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
run ansible-playbook
```
$ cd ~/k3s-demo/install-k3s-playbook
$ ansible-playbook -K -D site.yml
```
login to [ArgoCD](https://argocd.k3sdemo.lan/), [Kubernetes Dashboard](https://dashboard.k3sdemo.lan), view [Grafana Dashboards](https://grafana.k3sdemo.lan) or explore kubernetes by shell and kubectl.

make sure to reload your shell environment.
```
$ source ~/.profile
$ source ~/.bashrc
```
