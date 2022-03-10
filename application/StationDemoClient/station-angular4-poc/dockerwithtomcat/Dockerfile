FROM tomcat:9.0.38-jdk8-openjdk

MAINTAINER Karim GZ "kagzouli@exaka.com"


COPY conf/server.xml /usr/local/tomcat/conf/server.xml
COPY conf/web.xml /usr/local/tomcat/conf/web.xml

# Raison de sécurité - On desactive les applications par default et on met une 404.html
RUN rm -rf /usr/local/tomcat/webapps/*
RUN mkdir /usr/local/tomcat/webapps/ROOT
COPY page/404.html /usr/local/tomcat/webapps/ROOT/404.html
COPY page/500.html /usr/local/tomcat/webapps/ROOT/500.html

ADD station-angular4-poc.war /usr/local/tomcat/webapps/station-angular4-poc.war
