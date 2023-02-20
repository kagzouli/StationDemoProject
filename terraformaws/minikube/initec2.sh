Content-Type: multipart/mixed; boundary="===============BOUNDARY=="
MIME-Version: 1.0
 
--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
 
#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -x

export PATH=$PATH:/usr/local/bin
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent#Restart SSM agent
systemctl restart amazon-ssm-agent

sudo apt-get update




# Configuration before
modprobe br_netfilter
sysctl net.bridge.bridge-nf-call-iptables=1



sudo cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

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
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
apt-get update
apt-get install -y docker kubectl=1.25.4-00 


#Installation helm
sudo curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# Installation minikube
sudo usermod -aG docker ssm-user && newgrp docker
cd ~
sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube 
sudo ./minikube start --memory 6144 --force &



alias k=kubectl

--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-boothook; charset="us-ascii"
 
#cloud-boothook
 
--===============BOUNDARY==--

