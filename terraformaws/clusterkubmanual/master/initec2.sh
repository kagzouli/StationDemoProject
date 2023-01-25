Content-Type: multipart/mixed; boundary="===============BOUNDARY=="
MIME-Version: 1.0
 
--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
 
#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -x

export PATH=$PATH:/usr/local/bin
sudo yum install amazon-ssm-agent -y
sudo yum update -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#Restart SSM agent
systemctl restart amazon-ssm-agent

sudo yum update -y

# Patch
yum install -y yum-plugin-kernel-livepatch
yum kernel-livepatch enable -y
yum update kpatch-runtime -y
systemctl enable kpatch.service
amazon-linux-extras enable livepatch
sudo bash -c 'cat << EOF > /home/ec2-user/security_patches.log
0 1 * * * sudo yum update --security -y 
EOF'
chmod 600 /var/spool/cron/ec2-user
chown ec2-user:ec2-user /var/spool/cron/ec2-user
sudo systemctl reload crond.service

sudo setenforce 0


#Restart the Docker daemon
sudo systemctl restart docker


sudo bash -c 'cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'

# Install kubernetes component
sudo yum install -y docker kubelet-1.24.9-0 kubeadm-1.24.9-0 kubectl-1.24.9-0 kubernetes-cni-1.1.1-0


#Enable kubelet
sudo systemctl enable kubelet

sudo kubeadm config images pull

sudo kubeadm init --kubernetes-version 1.24.0  --pod-network-cidr=${cidr_block_vpc}

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

helm upgrade -i calico calico/tigera-operator --version v3.23.5

sudo yum install -y git

--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-boothook; charset="us-ascii"
 
#cloud-boothook
 
--===============BOUNDARY==--

