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




sudo bash -c 'cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'

sudo cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

# Install containerd
wget https://github.com/containerd/containerd/releases/download/v1.6.2/containerd-1.6.2-linux-amd64.tar.gz
sudo tar Czxvf /usr/local containerd-1.6.2-linux-amd64.tar.gz
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
sudo apt-get install -y docker kubelet=1.25.4-00 kubeadm=1.25.4-00 kubectl=1.25.4-00 kubernetes-cni=1.1.1-00


#Enable kubelet
sudo systemctl enable kubelet

sudo kubeadm config images pull

sudo apt install selinux-utils
sudo setenforce 0
sudo kubeadm init --kubernetes-version 1.25.0  --pod-network-cidr=${cidr_block_vpc}


# Ip tables
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -F

# Copy config
#sudo mkdir -p ~/.kube
#sudo cp /etc/kubernetes/admin.conf ~/.kube/config
#sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

mkdir -p ~/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config



#Installation helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo sh get_helm.sh
helm repo add calico https://docs.projectcalico.org/charts
helm repo update

sudo kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

sudo apt-get install -y git
sudo apt-get install -y jq

sudo apt-get -y install pkgconfig
ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/csbuild:/DBA/CentOS_CentOS-7/x86_64/libmozjs185-1_0-1.8.5-2.4.x86_64.rpm
sudo apt-get install elinks -y


# For load tests
sudo apt-get install -y wget
sudo wget https://github.com/grafana/k6/releases/download/v0.42.0/k6-v0.42.0-linux-amd64.tar.gz
sudo tar -xvf k6-v0.42.0-linux-amd64.tar.gz
sudo mv k6-v0.42.0-linux-amd64/k6 /usr/local/bin/k6

# Add entry for DNS simulation
sudo echo "172.16.16.210 stationback.exakaconsulting.org" >> /etc/hosts
sudo echo "172.16.16.210 station.exakaconsulting.org" >> /etc/hosts


alias k=kubectl

--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-boothook; charset="us-ascii"
 
#cloud-boothook
 
--===============BOUNDARY==--

