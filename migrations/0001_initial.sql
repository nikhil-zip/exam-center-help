PRAGMA foreign_keys = ON;
CREATE TABLE users (
 id TEXT PRIMARY KEY, email TEXT NOT NULL UNIQUE, password_hash TEXT NOT NULL,
 role TEXT NOT NULL CHECK(role IN ('admin','moderator')), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE exam_centres (
 id TEXT PRIMARY KEY, centre_code TEXT UNIQUE, name TEXT NOT NULL, city TEXT NOT NULL,
 address TEXT, nearby_place TEXT, map_url TEXT, latitude REAL, longitude REAL,
 status TEXT NOT NULL CHECK(status IN ('pending','approved','rejected','archived')) DEFAULT 'pending',
 source TEXT NOT NULL DEFAULT 'submission', verified INTEGER NOT NULL DEFAULT 0,
 submitted_by TEXT REFERENCES users(id), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE businesses (
 id TEXT PRIMARY KEY, name TEXT NOT NULL, category TEXT NOT NULL, owner_name TEXT NOT NULL,
 email TEXT NOT NULL, phone TEXT, city TEXT NOT NULL, address TEXT NOT NULL,
 latitude REAL, longitude REAL, status TEXT NOT NULL CHECK(status IN ('pending','approved','rejected','archived')) DEFAULT 'pending',
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE inquiries (
 id TEXT PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL, phone TEXT, city TEXT,
 subject TEXT NOT NULL, message TEXT NOT NULL, status TEXT NOT NULL CHECK(status IN ('new','in_progress','resolved','archived')) DEFAULT 'new',
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE reports (
 id TEXT PRIMARY KEY, centre_id TEXT REFERENCES exam_centres(id), name TEXT NOT NULL, email TEXT NOT NULL,
 report_type TEXT NOT NULL CHECK(report_type IN ('correction','new_centre')), details TEXT NOT NULL,
 status TEXT NOT NULL CHECK(status IN ('new','in_progress','resolved','rejected')) DEFAULT 'new',
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE admin_sessions (
 id TEXT PRIMARY KEY, user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 token_hash TEXT NOT NULL UNIQUE, expires_at TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE audit_logs (
 id TEXT PRIMARY KEY, user_id TEXT NOT NULL REFERENCES users(id), action TEXT NOT NULL,
 entity_type TEXT NOT NULL, entity_id TEXT NOT NULL, details TEXT,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_centres_status_city ON exam_centres(status, city);
CREATE INDEX idx_centres_code ON exam_centres(centre_code);
CREATE INDEX idx_business_status_city ON businesses(status, city);
CREATE INDEX idx_inquiries_status ON inquiries(status, created_at);
CREATE INDEX idx_reports_status ON reports(status, created_at);
CREATE INDEX idx_sessions_expiry ON admin_sessions(expires_at);
CREATE INDEX idx_audit_created ON audit_logs(created_at);
