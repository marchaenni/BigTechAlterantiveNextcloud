# BigTechAlterantiveNextcloud

Wird als Demo Umgebung für NextCloud verwendet.

## Docker Compose Umgebung

Dieser Testserver nutzt mehrere Container, um möglichst viele Nextcloud-Funktionen bereitzustellen:

- **Nextcloud** (App & Cron)
- **MariaDB** Datenbank
- **Redis** für Caching
- **NGINX** Reverse Proxy
- **Certbot** für Let's-Encrypt-Zertifikate
- **OnlyOffice** Dokumentenserver
- **Collabora Online**

### Vorbereitung

1. Kopiere die Beispieldatei und passe Domain sowie E-Mail-Adresse an:

   ```bash
   cp .env.example .env
   # .env editieren und NEXTCLOUD_DOMAIN sowie LETSENCRYPT_EMAIL setzen
   ```

   Die Domain muss bereits öffentlich erreichbar sein und per DNS auf den Server zeigen, damit Let's Encrypt ein Zertifikat ausstellen kann.

2. Starte die Container im Hintergrund:

   ```bash
   docker compose up -d
   ```

3. Beantrage das erste TLS-Zertifikat (ersetze die Platzhalter aus deiner `.env` Datei):

   ```bash
   docker compose run --rm certbot certonly \
     --webroot -w /var/www/certbot \
     -d "$NEXTCLOUD_DOMAIN" \
     --email "$LETSENCRYPT_EMAIL" \
     --agree-tos --no-eff-email
   ```

4. Lade anschließend die NGINX-Konfiguration neu, damit das Zertifikat genutzt wird:

   ```bash
   docker compose exec nginx nginx -s reload
   ```

Certbot kümmert sich danach automatisch um die Verlängerung (`certbot`-Service führt regelmäßig `certbot renew` aus). Nach einer erfolgreichen Verlängerung muss der NGINX-Container einmal neu geladen werden, z. B. per Cronjob:

```bash
docker compose exec nginx nginx -s reload
```

### Zugriff

Der Webzugriff erfolgt anschließend über `https://<deine-domain>`.

Weitere Dienste (weiterhin unverschlüsselt im lokalen Netz erreichbar):

- OnlyOffice: Port 8081
- Collabora: Port 9980
