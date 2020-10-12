FROM nginx:latest

MAINTAINER Karim GZ "kagzouli@exaka.com"

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD page/404.html /usr/share/nginx/404.html

RUN rm -rf /usr/share/nginx/html/*
ADD dist /usr/share/nginx/html/

ADD conf/configuration.json /usr/share/nginx/html/station-angular4-poc/assets/config/

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh 
ENTRYPOINT ["docker-entrypoint.sh"]
