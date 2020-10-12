#!/bin/bash
sed -i -e 's|{CLIENT_ID_TRAF_STAT}|'"$CLIENT_ID_TRAF_STAT"'|g' /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json
sed -i -e 's|{OKTA_URL}|'"$OKTA_URL"'|g' /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json
sed -i -e 's|{CONTEXT_BACK_URL}|'"$CONTEXT_BACK_URL"'|g' /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json
nginx -g 'daemon off;'
