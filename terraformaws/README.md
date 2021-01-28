# Station Demo

The architecture of the projet is based on AWS component. This is the AWS architecture schema of the project : 


![picture](./schemaArchitectureAWS.png)



The StationDemoProject directory is divided into differents parts :

### networks

 - This part is used to create the network part of the project (VPC , subnet, internal Gateway, Route53)

### ecsec2
  
 - This part is used to create all the station based on ECS EC2 and docker image stored in dockerhub of the project Station Demo 

### ecsfargate
  
 - This part is used to create all the station based on ECS fargate and docker image stored in dockerhub of the project Station Demo
 
### stationdb_rds
  
 - This part is used to create the database AWS RDS of the project Station Demo

### stationredis
  
 - This part is used to create the redis cache of the project Station Demo


### vars
  
 - This part is used to configure all the environments




