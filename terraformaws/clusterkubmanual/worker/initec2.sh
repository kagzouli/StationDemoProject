Content-Type: multipart/mixed; boundary="===============BOUNDARY=="
MIME-Version: 1.0
 
--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
 
#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -x

sudo cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

export PATH=$PATH:/usr/local/bin
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent
systemctl restart amazon-ssm-agent

sudo apt-get update


# Install containerd
wget https://github.com/containerd/containerd/releases/download/v1.6.16/containerd-1.6.16-linux-amd64.tar.gz
sudo tar Czxvf /usr/local containerd-1.6.16-linux-amd64.tar.gz
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
sudo systemctl status containerd
rm /etc/containerd/config.toml
systemctl restart containerd

#Restart the Docker daemon
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker


# Install kubernetes component
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo setenforce 0
sudo apt-get install -y docker kubelet=1.25.4-00 kubeadm=1.25.4-00 kubernetes-cni=1.1.1-00


#Enable kubelet
sudo systemctl enable kubelet

sudo kubeadm config images pull

# For load tests
sudo apt-get install -y wget
sudo wget https://github.com/grafana/k6/releases/download/v0.42.0/k6-v0.42.0-linux-amd64.tar.gz
sudo tar -xvf k6-v0.42.0-linux-amd64.tar.gz
sudo mv k6-v0.42.0-linux-amd64/k6 /usr/local/bin/k6

# Install tools
sudo apt-get install -y git
sudo apt-get install -y jq

# Add entry for DNS simulation
sudo echo "172.16.16.210 stationback.exakaconsulting.org" >> /etc/hosts
sudo echo "172.16.16.210 station.exakaconsulting.org" >> /etc/hosts


# Install app-armor profile k8s-stationfront-nginx
sudo apparmor_parser -q <<EOF
#include <tunables/global>
profile k8s-stationfront-nginx flags=(attach_disconnected) {
  #include <abstractions/base>
  #include <abstractions/nameservice>
  #include <abstractions/apache2-common>
  #include <abstractions/nis>
  #include <abstractions/openssl>
  #include <abstractions/ssl_keys>

  capability dac_override,
  capability dac_read_search,
  capability net_bind_service,
  capability setgid,
  capability setuid,
  network inet tcp,

  # pour écrire dans la console
  /dev/pts/[0-9] rw,

  # binary, pid
  /usr/bin/nginx mr,
  /run/nginx.pid rw
  /var/run/nginx.pid rw

  # configuration
  /etc/nginx r,
  /etc/nginx/** rl,
  /usr/share/nginx r,
  
  /etc/ssl r,
  /etc/ssl/openssl.cnf r,

  # cache
  owner /var/cache/nginx rw,
  owner /var/cache/nginx/** rw,
  owner /var/lib/nginx rw,
  owner /var/lib/nginx/** rw,

  # webroot
  owner /var/www/html rw,
  owner /var/www/html/** rw,
  owner /usr/share/nginx/html/** rw,

  # logs
  owner /var/log/nginx/* rw
}
EOF


# Install app-armor profile k8s-stationback
sudo apparmor_parser -q <<EOF
#include <tunables/global>
profile k8s-stationback flags=(attach_disconnected) {
  #include <abstractions/base>
  #include <abstractions/nameservice>
  #include <abstractions/apache2-common>
  #include <abstractions/nis>
  #include <abstractions/openssl>
  #include <abstractions/ssl_keys>

  capability dac_override,
  capability dac_read_search,
  capability net_bind_service,
  capability setgid,
  capability setuid,
  network inet tcp,

  # pour écrire dans la console
  /dev/pts/[0-9] rw,

  # webroot
  owner /usr/local/tomcat/** rw,

}
EOF


--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-boothook; charset="us-ascii"
 
#cloud-boothook
 
--===============BOUNDARY==--

