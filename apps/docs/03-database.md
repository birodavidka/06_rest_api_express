**Project:** ServiceDesk REST API

**Version:** 1.0

**Satus:** Draft

**Last Updated:** 2026-10-09

## 03 - database

### compose.yaml

```docker
services:
  postgres:
    image: postgres:17-alpine
    container_name: rest-api-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: app_user
      POSTGRES_PASSWORD: local_password
      POSTGRES_DB: rest_api
    ports:
      - "127.0.0.1:5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./db/init:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app_user -d rest_api"]
      interval: 5s
      timeout: 5s
      retries: 10

volumes:
  postgres_data:
```

### PostgreSQL database

Start PostgreSQL in Docker:

```bash
docker compose up -d
```

For a new database volume, Docker automatically runs these files in order:

```text
db/init/001_schema.sql
db/init/002_seed.sql
```

The seed contains example users, assets, tickets, and comments. Every example
user has the following development-only password:

```text
Password123!
```

If the PostgreSQL volume already existed before the initialization files were
added, load them manually:

```bash
docker compose exec -T postgres psql -X -U app_user -d rest_api \
  -v ON_ERROR_STOP=1 -f /docker-entrypoint-initdb.d/001_schema.sql

docker compose exec -T postgres psql -X -U app_user -d rest_api \
  -v ON_ERROR_STOP=1 -f /docker-entrypoint-initdb.d/002_seed.sql
```

The seed file can be run again safely. To inspect the database interactively:

```bash
docker compose exec postgres psql -U app_user -d rest_api
```

Useful commands inside `psql`:

```text
\dt
SELECT id, name, email, role FROM users;
SELECT id, title, status, priority FROM tickets;
\q
```

The API still uses its in-memory data store. Creating the database does not yet
connect the authentication endpoints to PostgreSQL.