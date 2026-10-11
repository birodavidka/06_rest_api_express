BEGIN;

CREATE TYPE user_role AS ENUM ('USER', 'TECHNICIAN', 'ADMIN');
CREATE TYPE ticket_status AS ENUM ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED');
CREATE TYPE ticket_priority AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');
CREATE TYPE asset_status AS ENUM ('ACTIVE', 'REPAIR', 'RETIRED');

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  email VARCHAR(320) NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  role user_role NOT NULL DEFAULT 'USER',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT users_email_lowercase CHECK (email = LOWER(email))
);

CREATE TABLE assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hostname VARCHAR(255) NOT NULL,
  type VARCHAR(100) NOT NULL,
  serial_number VARCHAR(100) NOT NULL UNIQUE,
  owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
  status asset_status NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  status ticket_status NOT NULL DEFAULT 'OPEN',
  priority ticket_priority NOT NULL DEFAULT 'MEDIUM',
  created_by_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  assigned_to_id UUID REFERENCES users(id) ON DELETE SET NULL,
  asset_id UUID REFERENCES assets(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  closed_at TIMESTAMPTZ,
  CONSTRAINT tickets_dates_valid CHECK (
    updated_at >= created_at
    AND (closed_at IS NULL OR closed_at >= created_at)
  ),
  CONSTRAINT closed_ticket_has_closed_at CHECK (
    status <> 'CLOSED' OR closed_at IS NOT NULL
  )
);

CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  body TEXT NOT NULL CHECK (LENGTH(BTRIM(body)) > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX tickets_created_by_id_idx ON tickets(created_by_id);
CREATE INDEX tickets_assigned_to_id_idx ON tickets(assigned_to_id);
CREATE INDEX tickets_asset_id_idx ON tickets(asset_id);
CREATE INDEX tickets_status_priority_idx ON tickets(status, priority);
CREATE INDEX comments_ticket_id_created_at_idx ON comments(ticket_id, created_at);
CREATE INDEX comments_author_id_idx ON comments(author_id);
CREATE INDEX assets_owner_id_idx ON assets(owner_id);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tickets_set_updated_at
BEFORE UPDATE ON tickets
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

COMMIT;
