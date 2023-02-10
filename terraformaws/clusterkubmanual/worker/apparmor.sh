#!/bin/bash

# Execute apparmor front nginx
sudo apparmor_parser -q <<EOF
#include <tunables/global>
profile k8s-stationfront-nginx flags=(attach_disconnected) {
#include <abstractions/base>
#include <abstractions/nameservice>
#include <abstractions/apache2-common>
#include <abstractions/nis>
#include <abstractions/openssl>
#include <abstractions/ssl_keys>
capability dac_override,
capability dac_read_search,
capability net_bind_service,
capability setgid,
capability setuid,
network inet tcp,
# pour écrire dans la console
/dev/pts/[0-9] rw,
# binary, pid
/usr/bin/nginx mr,
/run/nginx.pid rw,
/var/run/nginx.pid rw,
# configuration
/etc/nginx r,
/etc/nginx/** rl,
/usr/share/nginx r,
/etc/ssl r,
/etc/ssl/openssl.cnf r,
# cache
owner /var/cache/nginx rw,
owner /var/cache/nginx/** rw,
owner /var/lib/nginx rw,
owner /var/lib/nginx/** rw,
# webroot
owner /var/www/html rw,
owner /var/www/html/** rw,
owner /usr/share/nginx/html/** rw,
# logs
owner /var/log/nginx/* rw
}
EOF

# Execute apparmor back
sudo apparmor_parser -q <<EOF
#include <tunables/global>
profile k8s-stationback flags=(attach_disconnected) {
#include <abstractions/base>
#include <abstractions/nameservice>
#include <abstractions/apache2-common>
#include <abstractions/nis>
#include <abstractions/openssl>
#include <abstractions/ssl_keys>
capability dac_override,
capability dac_read_search,
capability net_bind_service,
capability setgid,
capability setuid,
network inet tcp,
# pour écrire dans la console
/dev/pts/[0-9] rw,
# webroot
owner /usr/local/tomcat/** rw,
}
EOF

sudo  ~/k8s-stationfront-nginx
sudo apparmor_parser -q ~/k8s-stationback