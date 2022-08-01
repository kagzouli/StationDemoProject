# Station Demo

The architecture of the projet is based on AWS component. This is the AWS architecture schema of the project : <br/>

We use Terraform version 0.15.5
<br/><br/>


![picture](./schemaArchitectureAWS.png)
<br/><br/><br/>


The StationDemoProject directory is divided into differents parts :

### secrets 

 - This part is used to create the secrets for all the project (Only use for database in the POC)

### networks

 - This part is used to create the network part of the project (VPC , subnet, internal Gateway, Route53)

### ecsec2
  
 - This part is used to create all the station based on ECS EC2 and docker image stored in dockerhub of the project Station Demo 

### ecsfargate
  
 - This part is used to create all the station based on ECS fargate and docker image stored in dockerhub of the project Station Demo
 
### eks 
  
 - This part is used to create all the station based on EKS fargate and docker image stored in dockerhub of the project Station Demo
 
### ec2instance 
  
 - This part is used to create a EC2 instance in the private subnet
 
### cloudwatchalarm 
  
 - This part is used to create alarm and notifications when some production errors occurs

### cloudwatchevent 
  
 - This part is used to create cloudwatch event to launch lambda for monitoring

### stationdb_rds
  
 - This part is used to create the database AWS RDS of the project Station Demo

### stationredis
  
 - This part is used to create the redis cache of the project Station Demo

### efs 
  
 - This part is used to create the EFS storage for the usage of a container docker mysql (If we do not use RDS)

### ecr
  
 - This part is used to create the ECR registry of the project Station Demo (If we want to use it)

### user 
  
 - This part is used to create the user/role of the project Station Demo (If we want to use it)

### apigateways
  
 - This part is just a sample to show how to create apigateways

### vars
  
 - This part is used to configure all the environments




