FROM nginx:latest

LABEL  application.contact = "kagzouli@exaka.com"

RUN rm -rf /usr/share/nginx/html/*
ADD dist /usr/share/nginx/html/


COPY setup.sh /usr/share/nginx/setup.sh
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/configuration.json /usr/share/nginx/html/station-angular4-poc/assets/config/
ADD page/404.html /usr/share/nginx/404.html


RUN chmod u+rx,a+x /usr/share/nginx/setup.sh \
    && chown -R nginx:nginx /usr/share/nginx \
    && chown -R nginx:nginx /var/log/nginx\
    && chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /var/run \
    && chown -R nginx:nginx /etc/nginx/conf.d  \
    && touch /var/run/nginx.pid \
    && chown -R nginx:nginx /var/run/nginx.pid
        

# On se connecte avec l'utilisateur nginx
USER nginx 

WORKDIR /usr/share/nginx

CMD ["/usr/share/nginx/setup.sh"]
