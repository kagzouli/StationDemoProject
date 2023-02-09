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

# Patch

sudo setenforce 0


sudo apt-get install -y git
sudo apt-get install -y jq

# Vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get install -y vault

# Insertion repertoire pour vault
sudo mkdir -p /etc/vault
chown vault:vault /etc/vault
sudo mkdir -p /opt/vault-data
chown vault:vault /opt/vault-data



# Fichier de configuration vault
sudo bash -c 'cat << EOF > /etc/vault/config.hcl

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr = "http://stationvault.exakaconsulting.org:8200"
storage "file" {
  path    = "/opt/vault-data"
}
max_lease_ttl = "10h"
default_lease_ttl = "10h"
ui = true
EOF'

# Creation fichier service
sudo bash -c 'cat << EOF > /etc/systemd/system/vault.service
[Unit]
Description=vault service
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/config.hcl

[Service]
User=vault
Group=vault
ExecStart=/usr/bin/vault server -config=/etc/vault/config.hcl
ExecReload=/usr/local/bin/kill --signal HUP $MAINPID
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
AmbientCapabilities=CAP_IPC_LOCK
EnvironmentFile=-/etc/sysconfig/vault
Restart=on-failure
LimitMEMLOCK=infinity
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF'

# Restart vault
systemctl start vault



--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-boothook; charset="us-ascii"
 
#cloud-boothook
 
--===============BOUNDARY==--

