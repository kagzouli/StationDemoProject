FROM mysql:8.0.30

LABEL  application.contact = "kagzouli@exaka.com"

ADD conf/stationdb.conf /etc/mysql/mysql.conf.d/stationdb.conf
ADD init/db-station-trafstat.sql /docker-entrypoint-initdb.d/db-station-trafstat.sql
