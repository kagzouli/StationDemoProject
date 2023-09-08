FROM eclipse-temurin:17-jre

LABEL application.contact = "kagzouli@exaka.com"

# Variabl environnement
ENV DB_TRAFSTAT_URL "jdbc:h2:file:~/data/trafstats1;INIT=create schema if not exists trafstats1\\;RUNSCRIPT FROM 'classpath:db-data-h2-trafstat.sql'"
ENV DB_TRAFSTAT_DRIVERCLASS "org.h2.Driver"
ENV DB_TRAFSTAT_USERNAME "sa"
ENV DB_TRAFSTAT_PASSWORD ""
ENV DB_TRAFSTAT_MAXACTIVE "10"
ENV REDIS_HOSTNAME "localhost"
ENV REDIS_PORT "6379"
ENV REDIS_PASS "test650"
ENV REDIS_USESSL "false"

COPY StationDemoSecureWeb.jar StationDemoSecureWeb.jar

RUN  groupadd -r -g 20050 exakagroup && useradd -u 20050 -r -g exakagroup exakauser \
    && chown -R exakauser:exakagroup StationDemoSecureWeb.jar


# Run with user tomcat
USER exakauser
ENTRYPOINT ["java" , "-XX:MaxRAMPercentage=75.0" , "-XX:+UseContainerSupport" , "-jar" , "StationDemoSecureWeb.jar"]
