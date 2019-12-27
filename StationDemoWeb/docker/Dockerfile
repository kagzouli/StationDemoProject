FROM tomcat:latest

MAINTAINER Karim GZ "kagzouli@exaka.com"

ADD conf/context.xml /usr/local/tomcat/conf/context.xml
ADD conf/web.xml /usr/local/tomcat/conf/web.xml

RUN  wget -O mariadb-java-client-2.5.2.jar "https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/2.5.2/mariadb-java-client-2.5.2.jar"
RUN cp mariadb-java-client-2.5.2.jar /usr/local/tomcat/lib/mariadb-java-client-2.5.2.jar

ADD bin/setenv.sh /usr/local/tomcat/bin/setenv.sh

ADD ../target/StationDemoSecureWeb.war /usr/local/tomcat/webapps/StationDemoSecureWeb.war
