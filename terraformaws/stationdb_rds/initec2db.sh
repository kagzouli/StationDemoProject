Content-Type: multipart/mixed; boundary="===============BOUNDARY=="
MIME-Version: 1.0

--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -x


export PATH=$PATH:/usr/local/bin
yum install amazon-ssm-agent -y
yum update -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#Restart SSM agent
systemctl restart amazon-ssm-agent

sudo yum update -y

# Init mysql
sudo yum install -y mysql

sudo touch /tmp/stationdbinit.sql
sudo chmod 777 /tmp/stationdbinit.sql

echo "CREATE DATABASE IF NOT EXISTS StationDemoDb;  use StationDemoDb; DROP TABLE IF EXISTS TRAF_STAT; CREATE TABLE TRAF_STAT (       TRAF_IDEN integer primary key auto_increment not null,  TRAF_RESE varchar(16) not null ,        TRAF_STAT varchar(128) not null ,       TRAF_TRAF bigint not null ,     TRAF_CORR varchar(128),         TRAF_VILL varchar(128) not null,        TRAF_ARRO integer );  INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'GARE DE LYON' , '36352115' , '1,14,A' ,'Paris' , 12); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'REPUBLIQUE' , '18340798' , '3,5,8,9,11' ,'Paris' , 11);INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'PLACE D''ITALIE' , '11462253' , '5,6,7' ,'Paris' , 13); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'FRANKLIN D. ROOSEVELT' , '10899310' , '1,9' ,'Paris' , 8); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'NATION' , '8792715' , '1,2,6,9' ,'Paris' , 12); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'TROCADERO' , '8351649' , '6,9' ,'Paris' , 16); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'AUBERVILLIERS-PANTIN-QUATRE CHEMINS' , '7381123' , '7' ,'Aubervilliers' , NULL); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'MADELEINE' , '6992609' , '8,12,14' ,'Paris' , 8); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'GRANDS BOULEVARDS' , '6889717' , '8,9' ,'Paris' , 9); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'STALINGRAD' , '7063687' , '2,5,7' ,'Paris' , 19); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'INVALIDES' , '6290697' , '8,13' ,'Paris' , 7); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'JAURES' , '6133119' , '2,5,7bis' ,'Paris' , 19); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'ODEON' , '5896554' , '4,10' ,'Paris' , 6); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'LA COURNEUVE-8 MAI 1945' , '6013067' , '7' ,'La Courneuve' , NULL); INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ('Metro' , 'SEVRES-BABYLONE' , '5178469' , '10,12' ,'Paris' , 7);" > /tmp/stationdbinit.sql

sudo mysql -u${stationdb_user} -p${stationdb_pwd} -h${stationdb_hostname} < /tmp/stationdbinit.sql 


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

--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-boothook; charset="us-ascii"

#cloud-boothook

--===============BOUNDARY==--

