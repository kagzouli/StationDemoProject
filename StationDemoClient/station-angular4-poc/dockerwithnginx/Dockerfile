FROM nginx:latest

MAINTAINER Karim GZ "kagzouli@exaka.com"

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD page/404.html /usr/share/nginx/404.html

RUN rm -rf /usr/share/nginx/html/*
ADD dist /usr/share/nginx/html/

