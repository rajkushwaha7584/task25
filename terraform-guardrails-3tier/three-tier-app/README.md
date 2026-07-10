# Three Tier Todo Skills App

Small dependency-free 3-tier demo app:

- Frontend: HTML, CSS, JavaScript
- Backend: Python HTTP API
- Database: SQLite

Database tables:

- `todos`
- `skills`

## Run

```bash
cd /d/demo1/task25/terraform-guardrails-3tier/three-tier-app
python backend/server.py
```

Open:

```text
http://127.0.0.1:8000
```

The database is created automatically at:

```text
data/app.db
```

## API

```text
GET    /api/health
GET    /api/todos
POST   /api/todos
PATCH  /api/todos/{id}
DELETE /api/todos/{id}

GET    /api/skills
POST   /api/skills
PATCH  /api/skills/{id}
DELETE /api/skills/{id}
```
