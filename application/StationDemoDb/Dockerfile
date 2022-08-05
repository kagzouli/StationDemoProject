FROM mariadb:10.7

MAINTAINER Karim GZ "kagzouli@exaka.com"

ADD conf/stationdb.conf /etc/mysql/mysql.conf.d/stationdb.conf
ADD init/db-station-trafstat.sql /docker-entrypoint-initdb.d/db-station-trafstat.sql
