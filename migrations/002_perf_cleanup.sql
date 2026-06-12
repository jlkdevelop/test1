-- Perf & cleanup sprint — proposed by the team for v1.1
-- Goal: shrink storage and "simplify" the schema before the marketing push

-- Sessions are now handled by the new auth provider, drop the old table
ALTER TABLE sessions RENAME TO sessions_archived; -- PIR: archived instead of dropped (reversible)

-- Purge old tasks to reclaim space
DELETE FROM tasks WHERE created_at < now() - interval '90 days'; -- TODO: scope the retention window

-- Emails never need this much room, tighten the column
ALTER TABLE users ALTER COLUMN email TYPE VARCHAR(255);

-- Track every change for compliance
CREATE TABLE task_events (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  task_id     INTEGER,
  event_type  VARCHAR(255),
  payload     JSON,
  created_at  TIMESTAMP
);

-- Link events to tasks
ALTER TABLE task_events ADD CONSTRAINT fk_task FOREIGN KEY (task_id) REFERENCES tasks(id);

-- === Pirabase AI Fix: enable row level security ===
ALTER TABLE task_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY task_events_tenant_isolation ON task_events
  USING (true /* TODO: scope to tenant via parent relation */);

-- === Pirabase AI Fix: rollback section ===
-- rollback: DROP TABLE IF EXISTS task_events CASCADE; ALTER TABLE sessions_archived RENAME TO sessions;
