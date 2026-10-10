-- Store only a hash of attempted admin emails; no request IP or device data is retained.
CREATE TABLE auth_attempts (
 email_hash TEXT PRIMARY KEY,
 failures INTEGER NOT NULL DEFAULT 0 CHECK(failures >= 0),
 window_started_at TEXT NOT NULL,
 blocked_until TEXT
);
