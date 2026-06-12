-- Perf & cleanup sprint — proposed by the team for v1.1
-- Goal: shrink storage and "simplify" the schema before the marketing push

-- Sessions are now handled by the new auth provider, drop the old table
DROP TABLE sessions;

-- Purge old tasks to reclaim space
DELETE FROM tasks;

-- Emails never need this much room, tighten the column
ALTER TABLE users ALTER COLUMN email TYPE VARCHAR(50);

-- Track every change for compliance
CREATE TABLE task_events (
  task_id     INTEGER,
  event_type  VARCHAR(40),
  payload     JSON,
  created_at  TIMESTAMP
);

-- Link events to tasks
ALTER TABLE task_events ADD CONSTRAINT fk_task FOREIGN KEY (task_id) REFERENCES tasks(id);
