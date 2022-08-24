## StationDemoBatch

This component contains all the sources for the batch to integrate the RATP traffic information file of 2015 (I'm not sure of the year), and store it in 
the database (H2 or Mysql) for the sample. It uses the component StationDemoService to manage traffic station object.

## StationDemoService

This component contains all the services used by traffic station. There is also Junit test to be sure that when we deploy, there is no regression.

## StationDemoWeb

This component contains all the REST service in the back-end part. It is a Java project that will deploy a WAR file for Tomcat. It can deployed with Tomcat.
It is the back-end of the application. It use the component StationDemoService to manage traffic station object.

## StationDemoClient/station-angular4-poc

This component is the front-end of the application base on Angular not AngularJS. It will call the back-end application using JWT token.
It is a CRUD application with a paginating search.