#!/bin/bash
sed -i "s|{CLIENT_ID_TRAF_STAT}|${CLIENT_ID_TRAF_STAT}|g" /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json
sed -i "s|{OKTA_URL}|${OKTA_URL}|g" /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json
sed -i "s|{CONTEXT_BACK_URL}|${CONTEXT_BACK_URL}|g" /usr/share/nginx/html/station-angular4-poc/assets/config/configuration.json
