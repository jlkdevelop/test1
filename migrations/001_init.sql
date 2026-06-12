-- Taskflow production schema — v1
-- Applied to production (Neon: test1) on 2026-06-11

CREATE TABLE users (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email       VARCHAR(255) NOT NULL UNIQUE,
  name        VARCHAR(255) NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE tasks (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id     BIGINT NOT NULL REFERENCES users(id),
  title       VARCHAR(500) NOT NULL,
  status      VARCHAR(20) NOT NULL DEFAULT 'todo',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_tasks_user_id ON tasks(user_id);

CREATE TABLE sessions (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id     BIGINT NOT NULL REFERENCES users(id),
  token       VARCHAR(64) NOT NULL UNIQUE,
  expires_at  TIMESTAMPTZ NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_sessions_user_id ON sessions(user_id);

-- Row level security
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
CREATE POLICY tasks_owner ON tasks
  USING (user_id = current_setting('app.current_user_id', true)::bigint);

-- Seed data
INSERT INTO users (email, name) VALUES
  ('maria@taskflow.dev', 'Maria Lopez'),
  ('sam@taskflow.dev', 'Sam Chen');
INSERT INTO tasks (user_id, title, status) VALUES
  (1, 'Design onboarding flow', 'done'),
  (1, 'Ship billing page', 'in_progress'),
  (2, 'Fix mobile nav overflow', 'todo');

-- rollback: DROP POLICY IF EXISTS tasks_owner ON tasks;
-- rollback: DROP TABLE IF EXISTS sessions;
-- rollback: DROP TABLE IF EXISTS tasks;
-- rollback: DROP TABLE IF EXISTS users;
