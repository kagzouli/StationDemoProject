FROM eclipse-temurin:17-jre

LABEL application.contact = "kagzouli@exaka.com"


RUN  groupadd -r -g 20050 exakagroup && useradd -u 20050 -r -g exakauser exakagroup \ 


# Raison de sécurité - On desactive les applications par default et on met une 404.html
COPY page/404.html /usr/local/tomcat/webapps/ROOT/404.html
COPY StationDemoSecureWeb.war StationDemoSecureWeb.war

# Give this directory the tomcat right
RUN chown -R exakauser:exakagroup StationDemoSecureWeb.war
# Run with user tomcat
USER exakauser
WORKDIR /usr/local/tomcat/
