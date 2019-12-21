FROM tomcat:latest

MAINTAINER Karim GZ "kagzouli@exaka.com"

ADD lib/mysql-connector-java-8.0.18.jar /usr/local/tomcat/lib/mysql-connector-java-8.0.18.jar
ADD conf/context.xml /usr/local/tomcat/conf/context.xml
ADD conf/web.xml /usr/local/tomcat/conf/web.xml

ADD bin/setenv.sh /usr/local/tomcat/bin/setenv.sh

ADD webapps/StationDemoSecureWeb.war /usr/local/tomcat/webapps/StationDemoSecureWeb.war
