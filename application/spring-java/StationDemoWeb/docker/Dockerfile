FROM tomcat:10.1.5-jdk17-temurin

LABEL application.contact = "kagzouli@exaka.com"


RUN  groupadd -r -g 20050 tomcat && useradd -u 20050 -r -g tomcat tomcat \ 
 &&  wget -O mysql-connector-java-8.0.30.jar "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar" \
 &&  cp mysql-connector-java-8.0.30.jar /usr/local/tomcat/lib/mysql-connector-java-8.0.30.jar \
 &&  rm -rf /usr/local/tomcat/webapps/* \
 &&  mkdir /usr/local/tomcat/webapps/ROOT \
 &&  rm -f /usr/local/tomcat/mysql-connector-java-8.0.30.jar

ADD bin-set/setenv.sh /usr/local/tomcat/bin/setenv.sh
ADD conf/context.xml /usr/local/tomcat/conf/context.xml
ADD conf/server.xml /usr/local/tomcat/conf/server.xml
ADD conf/web.xml /usr/local/tomcat/conf/web.xml

# Raison de sécurité - On desactive les applications par default et on met une 404.html
COPY page/404.html /usr/local/tomcat/webapps/ROOT/404.html
COPY StationDemoSecureWeb.war /usr/local/tomcat/webapps/StationDemoSecureWeb.war

# Give this directory the tomcat right
RUN chown -R tomcat:tomcat /usr/local/tomcat
# Run with user tomcat
USER tomcat
WORKDIR /usr/local/tomcat/
