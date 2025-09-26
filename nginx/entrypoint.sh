#!/usr/bin/env bash
set -euo pipefail

: "${NEXTCLOUD_DOMAIN:?Environment variable NEXTCLOUD_DOMAIN must be set}"

CERT_DIR="/etc/letsencrypt/live/${NEXTCLOUD_DOMAIN}"
HTTP_TEMPLATE="/etc/nginx/templates/nextcloud.http.conf"
SSL_TEMPLATE="/etc/nginx/templates/nextcloud.ssl.conf"
CONF_PATH="/etc/nginx/conf.d/nextcloud.conf"

mkdir -p /var/www/certbot
mkdir -p /var/log/nginx

render_http() {
  envsubst '${NEXTCLOUD_DOMAIN}' < "$HTTP_TEMPLATE" > "$CONF_PATH"
}

render_ssl() {
  envsubst '${NEXTCLOUD_DOMAIN}' < "$SSL_TEMPLATE" > "$CONF_PATH"
}

have_cert() {
  [ -s "${CERT_DIR}/fullchain.pem" ] && [ -s "${CERT_DIR}/privkey.pem" ]
}

# 1) HTTP starten, damit ACME erreichbar ist
render_http
nginx

# 2) Wenn Zertifikat bereits vorhanden, sofort auf HTTPS umschalten
if have_cert; then
  echo "[entrypoint] Certificate found for ${NEXTCLOUD_DOMAIN}, enabling SSL"
  render_ssl
  nginx -s reload
fi

# 3) Auf Zertifikats-Änderungen warten und Nginx neu laden
(
  mkdir -p "${CERT_DIR}"
  if ! have_cert; then
    echo "[entrypoint] Waiting for initial certificate in ${CERT_DIR}..."
    while ! have_cert; do
      sleep 5
    done
    echo "[entrypoint] Initial certificate detected, switching to SSL"
    render_ssl
    nginx -s reload
  fi

  echo "[entrypoint] Watching for certificate renewals..."
  while inotifywait -e close_write,create,move "${CERT_DIR}"; do
    echo "[entrypoint] Certificate change detected, reloading nginx"
    nginx -s reload || true
  done
) &

# Prozess im Vordergrund halten
wait -n