# Taskflow (test1)

Task-tracking backend on **Neon Postgres** — the production app used to demo
**Pirabase Deploy Guard**'s Migration Readiness Check.

- `main` — production: schema `migrations/001_init.sql` is applied to the Neon
  `test1` database and the API is live.
- `dev` — proposed changes awaiting verification (`migrations/002_*.sql`).

## API
- `GET /api/health` — DB connectivity check
- `GET /api/tasks` — list tasks (joined with owners)
- `POST /api/tasks` — `{ "title": "..." }`

Check readiness to merge `dev → main` with Pirabase: connect this repo in the
dashboard and press **Check migration readiness**.
