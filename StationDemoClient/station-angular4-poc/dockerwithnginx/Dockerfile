FROM nginx:latest

MAINTAINER Karim GZ "kagzouli@exaka.com"

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD page/404.html /usr/share/nginx/404.html

RUN rm -rf /usr/share/nginx/html/*
ADD dist /usr/share/nginx/html/

ADD conf/configuration.json /usr/share/nginx/html/station-angular4-poc/assets/config/
RUN sed -i 's|{CLIENT_ID_TRAF_STAT}|${CLIENT_ID_TRAF_STAT}|g' /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json 
RUN sed -i 's|{OKTA_URL}|${OKTA_URL}|g' /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json
RUN sed -i 's|{CONTEXT_BACK_URL}|${CONTEXT_BACK_URL}|g' /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json
