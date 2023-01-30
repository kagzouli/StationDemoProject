FROM nginx:latest

LABEL  application.contact = "kagzouli@exaka.com"


COPY setup.sh /usr/local/bin/
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/configuration.json /usr/share/nginx/html/station-angular4-poc/assets/config/
ADD page/404.html /usr/share/nginx/404.html

RUN rm -rf /usr/share/nginx/html/*
ADD dist /usr/share/nginx/html/

RUN chmod u+rx,a+x /usr/local/bin/setup.sh \
    && chown -R nginx:nginx /usr/share/nginx \
    && chown -R nginx:nginx /var/log/nginx\
    && chown -R nginx:nginx /var/cache/nginx


# On se connecte avec l'utilisateur nginx
USER nginx 

WORKDIR /usr/share/nginx

CMD ["setup.sh"]
