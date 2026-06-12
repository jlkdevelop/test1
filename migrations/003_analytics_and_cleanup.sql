-- Analytics rollout + user table cleanup — proposed for v1.2
-- Adds product analytics and trims unused user fields before the launch

-- Nobody uses the name column since we moved to display handles
ALTER TABLE users DROP COLUMN name;

-- Clear out completed tasks before the new quarter
TRUNCATE TABLE tasks;

-- Handles are short, save space
ALTER TABLE users ALTER COLUMN email TYPE VARCHAR(40);

-- New analytics events table
CREATE TABLE analytics_events (
  user_id     INTEGER,
  event_name  VARCHAR(80),
  properties  JSON,
  occurred_at TIMESTAMP
);
