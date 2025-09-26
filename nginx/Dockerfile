FROM nginx:1.27-alpine

# envsubst + inotify-tools + openssl für dhparam
RUN apk add --no-cache bash gettext inotify-tools openssl

COPY entrypoint.sh /entrypoint.sh
COPY templates /etc/nginx/templates

# simple dhparam (optional)
RUN mkdir -p /etc/ssl/certs && \
    openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

ENV NEXTCLOUD_DOMAIN=localhost
ENTRYPOINT ["/entrypoint.sh"]
