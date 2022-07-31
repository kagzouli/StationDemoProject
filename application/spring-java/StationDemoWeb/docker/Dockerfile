FROM tomcat:9.0.38-jdk8-openjdk

MAINTAINER Karim GZ "kagzouli@exaka.com"


RUN  wget -O mariadb-java-client-2.5.2.jar "https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/2.5.2/mariadb-java-client-2.5.2.jar"
RUN cp mariadb-java-client-2.5.2.jar /usr/local/tomcat/lib/mariadb-java-client-2.5.2.jar

ADD bin-set/setenv.sh /usr/local/tomcat/bin/setenv.sh
ADD conf/context.xml /usr/local/tomcat/conf/context.xml
ADD conf/server.xml /usr/local/tomcat/conf/server.xml
ADD conf/web.xml /usr/local/tomcat/conf/web.xml

# Raison de sécurité - On desactive les applications par default et on met une 404.html
RUN rm -rf /usr/local/tomcat/webapps/*
RUN mkdir /usr/local/tomcat/webapps/ROOT
COPY page/404.html /usr/local/tomcat/webapps/ROOT/404.html


ADD StationDemoSecureWeb.war /usr/local/tomcat/webapps/StationDemoSecureWeb.war
