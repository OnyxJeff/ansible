## Environment Variables

Transmission uses a `.env` file for credentials and other machine-specific settings.

This file is **not included in Git**.

If deploying manually:

```bash
cp .env.example .env
nano .env
```

Populate the following values:

| Variable | Description |
|-----------|-------------|
| PUID | Linux user ID |
| PGID | Linux group ID |
| TZ | Timezone |
| TRANSMISSION_USER | Web UI username |
| TRANSMISSION_PASSWORD | Web UI password |

When deploying with Ansible, this file is created automatically from encrypted host variables. No manual configuration is required.