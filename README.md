# BigTechAlterantiveNextcloud

Wird als Demo Umgebung für NextCloud verwendet.

## Docker Compose Umgebung

Dieser Testserver nutzt mehrere Container, um möglichst viele Nextcloud-Funktionen bereitzustellen:

- **Nextcloud** (App & Cron)
- **MariaDB** Datenbank
- **Redis** für Caching
- **notify_push** für Push-Benachrichtigungen
- **OnlyOffice** Dokumentenserver
- **Collabora Online**

### Starten

```bash
docker compose up -d
```

Der Webzugriff erfolgt anschließend über [http://localhost:8080](http://localhost:8080).

Weitere Dienste:
- OnlyOffice: Port 8081
- Collabora: Port 9980
- Push-Server: Port 7867
