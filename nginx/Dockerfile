FROM nginx:alpine

RUN apk add --no-cache gettext

COPY conf.d/nextcloud.conf.template /etc/nginx/templates/nextcloud.conf.template
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
