CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TYPE user_role AS ENUM ('visitor', 'admin');
CREATE TYPE visit_status AS ENUM
  ('pending', 'approved', 'rejected', 'checked_in', 'completed', 'cancelled');

CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name     TEXT NOT NULL,
  email         TEXT NOT NULL UNIQUE,
  phone         TEXT,
  password_hash TEXT,
  google_id     TEXT UNIQUE,
  role          user_role NOT NULL DEFAULT 'visitor',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE visit_types (
  id             SERIAL PRIMARY KEY,
  name           TEXT NOT NULL UNIQUE,
  description    TEXT,
  daily_capacity INT NOT NULL DEFAULT 50 CHECK (daily_capacity > 0),
  is_active      BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE visits (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  visit_type_id    INT NOT NULL REFERENCES visit_types(id),
  visit_date       DATE NOT NULL,
  purpose          TEXT,
  status           visit_status NOT NULL DEFAULT 'pending',
  qr_token         TEXT UNIQUE,
  rejection_reason TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_visits_user ON visits(user_id);
CREATE INDEX idx_visits_date_type ON visits(visit_date, visit_type_id);
CREATE INDEX idx_visits_status ON visits(status);

INSERT INTO visit_types (name, description, daily_capacity) VALUES
  ('Campus tour', 'Guided tour of Konza Technology City', 40),
  ('Meet experts', 'Sessions with researchers and innovators', 20),
  ('Events', 'Conferences, workshops and open days', 100),
  ('Business meeting', 'Scheduled meetings with resident organisations', 30);
