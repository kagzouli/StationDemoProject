Content-Type: multipart/mixed; boundary="===============BOUNDARY=="
MIME-Version: 1.0

--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -x

echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config


export PATH=$PATH:/usr/local/bin
yum install amazon-ssm-agent -y
yum update -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#Restart SSM agent
systemctl restart amazon-ssm-agent

sudo yum update -y


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

