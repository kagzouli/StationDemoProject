Content-Type: multipart/mixed; boundary="===============BOUNDARY=="
MIME-Version: 1.0

--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -x

echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config


export PATH=$PATH:/usr/local/bin
yum install amazon-ssm-agent -y
yum update -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#Restart SSM agent
systemctl restart amazon-ssm-agent

sudo yum update -y

# Patch
yum install -y yum-plugin-kernel-livepatch
yum kernel-livepatch enable -y
yum update kpatch-runtime -y
systemctl enable kpatch.service
amazon-linux-extras enable livepatch
cat << EOF >
0 1 * * * sudo yum update --security -y >> /home/ec2-user/security_patches.log 2>&1
EOF
chmod 600 /var/spool/cron/ec2-user
chown ec2-user:ec2-user /var/spool/cron/ec2-user
sudo systemctl reload crond.service


#Stop the Amazon ECS container agent
sudo systemctl stop ecs.service
#Restart the Docker daemon
sudo systemctl restart docker
#Start the Amazon ECS container agent
sudo systemctl start ecs.service


--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-boothook; charset="us-ascii"

#cloud-boothook

--===============BOUNDARY==--

