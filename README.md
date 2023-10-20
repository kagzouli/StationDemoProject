# TrafficStation application demo  

This project is a simple CRUD application with a Mysql or H2 database , it allows to create, delete, update and read traffic station information.
It will also allow to search traffic stations information by criteria using pagination (With REST call)
It is based on a file that RATP has made online some years ago (This file is integrated to the database using a batch for the sample).
This project allows me to test some common concept architecture that are used in enterprise. 


# TrafficStation architecture 

This project is divided into multiples parts, a web application with the front-end in Angular and the back-end in SpringMVC (Little use also of Spring boot).
I use Okta for identity providing (More easy to manage). I use JWT token for the communication between the front-end and the back-end (Standard in industry).

There is also a batch part made with Spring batch. It calls business part to create some data. 
I use docker for more simplicity and more flexibility and kubernetes. Kubernetes will allow 
to manage the number of docker container that will start in the application (Increase or decrease the number depending of the HTTP traffic).
There is 2 docker images and 2 components for the DB and Redis in the application :


   - The front-end in Angular using Nginx in a docker image.
   - The back-end in SpringMVC and a little use of Spring boot using Tomcat server in a docker image.
   - The database with Mysql (Normally we must use a single datasource but for this test, there will be multiple datasources, one per kubernete pod deployed --> Bad practice, I use it only for test), There is also an example with docker-compose. But for AWS, I use a real configuration with RDS.
   - Redis which is use for AWS using ElastiCache.
       
Normally, everything must be encrypting with HTTPS but for the POC, I will not do it 

TODO : Improve this architecture schema

![picture](./schemaArchitectureGlobal.png)

# TrafficStation integration

I use maven for java sources and npm for Angular source. I also use a Jenkins container to build all the tasks.
I create 5 tasks : 

   - Build the project, generate docker images and push them in the regular or a custom docker registry
   - Start The application with docker-compose
   - Stop the application with docker-compose
   
## BuildStationDemoProject

The goal of this job is to build the project and generate docker images and push them in the regular docker registry. 
It takes 2 parameters : 

| Parameter  |  Description |
| ------------ | ------------ |
| VERSION |The version of the project  |
| REPO_NEXUS_URL | The URL of the docker container registry|

## startStationDemoDockerCompose

The goal of this job is to start the application using a docker-compose file. 
It takes 5 parameters : 

| Parameter  |  Description |
| ------------ | ------------ |
| VERSION |The version of the project  |
| REPO_NEXUS_URL | The URL of the docker container registry|
| DATABASE_DATA | The directory where the Mysql data is stored|
| MY_LOGS | The directory where the logs are stored|
| ANGULAR_CONFIG | The directory where the angular configuration file is stored|

## stopStationDemoDockerCompose

The goal of this job is to stop the application using a docker-compose file. 


# TrafficStation organization source




## usinedev

This directory is containing all the tools with docker that will be use for continious integration.

## jenkins

This directory contains all the jenkins pipeline to build, push image into custom or standard docker registry  and deploy the project using docker-compose.


## kubernetesaws

This directory contains the template to start kubernetes helm ArgoCD for the project in AWS. We have an helm directory and a argocd directory

## terraformaws

This directory contains all the terraform script to deploy StationDemo on AWS. 

## ansible

This directory contains all the script to deploy the station backend and the front end using a sas (saslivraison). The sas contains all the delivery.

## application

This directory contains all the sources of the application (Front and back)




 
