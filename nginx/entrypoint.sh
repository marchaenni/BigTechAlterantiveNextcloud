#!/bin/sh
set -eu

if [ -z "${NEXTCLOUD_DOMAIN:-}" ]; then
    echo "Environment variable NEXTCLOUD_DOMAIN must be set" >&2
    exit 1
fi

envsubst '${NEXTCLOUD_DOMAIN}' < /etc/nginx/templates/nextcloud.conf > /etc/nginx/conf.d/nextcloud.conf

exec nginx -g 'daemon off;'
