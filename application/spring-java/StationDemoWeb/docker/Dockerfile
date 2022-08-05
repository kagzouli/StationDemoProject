FROM tomcat:9.0.38-jdk8-openjdk

MAINTAINER Karim GZ "kagzouli@exaka.com"


RUN  wget -O mysql-connector-java-8.0.30.jar "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar"
RUN cp mysql-connector-java-8.0.30.jar /usr/local/tomcat/lib/mysql-connector-java-8.0.30.jar

ADD bin-set/setenv.sh /usr/local/tomcat/bin/setenv.sh
ADD conf/context.xml /usr/local/tomcat/conf/context.xml
ADD conf/server.xml /usr/local/tomcat/conf/server.xml
ADD conf/web.xml /usr/local/tomcat/conf/web.xml

# Raison de sécurité - On desactive les applications par default et on met une 404.html
RUN rm -rf /usr/local/tomcat/webapps/*
RUN mkdir /usr/local/tomcat/webapps/ROOT
COPY page/404.html /usr/local/tomcat/webapps/ROOT/404.html


COPY StationDemoSecureWeb.war /usr/local/tomcat/webapps/StationDemoSecureWeb.war
