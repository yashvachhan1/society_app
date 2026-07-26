-- =====================================================================
-- Society Management Platform — migration 001
-- Identity, society structure and membership
--
-- Covers exactly what the current app flow needs:
--     registration  ->  login  ->  dashboard (profile)
--
-- Tables: users · societies · towers · units · files · memberships ·
--         unit_occupancies
--
-- Billing, accounting, complaints, amenities, gate, meetings etc. come in
-- later migrations, when those modules are built.
--
-- Conventions (from the schema document):
--   * id BIGSERIAL primary keys, all foreign keys indexed
--   * every tenant-scoped table carries society_id
--   * created_at / updated_at TIMESTAMPTZ on every table
--   * money NUMERIC(12,2) — never float
--   * enums as TEXT + CHECK so they are easy to extend
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- Shared helper: keep updated_at current on every UPDATE
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ---------------------------------------------------------------------
-- 1. users
-- Global identities. A person exists once, no matter how many societies
-- they belong to. The phone number is the login (OTP).
-- ---------------------------------------------------------------------
CREATE TABLE users (
  id            BIGSERIAL PRIMARY KEY,
  phone         VARCHAR(15) NOT NULL UNIQUE,
  name          TEXT        NOT NULL,
  email         TEXT,
  photo_url     TEXT,
  language      TEXT        NOT NULL DEFAULT 'en'
                CHECK (language IN ('en', 'hi', 'mr')),
  status        TEXT        NOT NULL DEFAULT 'active'
                CHECK (status IN ('active', 'blocked')),
  last_login_at TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- stored normalised as +91XXXXXXXXXX
  CONSTRAINT users_phone_format CHECK (phone ~ '^\+[0-9]{10,14}$'),
  CONSTRAINT users_email_format
    CHECK (email IS NULL OR email ~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$')
);

COMMENT ON TABLE  users       IS 'Global user identities across all societies';
COMMENT ON COLUMN users.phone IS 'Primary login identifier (OTP); unique platform-wide';


-- ---------------------------------------------------------------------
-- 2. societies
-- One row per tenant society.
-- ---------------------------------------------------------------------
CREATE TABLE societies (
  id              BIGSERIAL PRIMARY KEY,
  name            TEXT      NOT NULL,
  registration_no TEXT      NOT NULL,
  address         TEXT      NOT NULL,
  city            TEXT      NOT NULL,
  state           TEXT      NOT NULL,
  pincode         TEXT      NOT NULL,
  logo_url        TEXT,
  fy_start_month  SMALLINT  NOT NULL DEFAULT 4
                  CHECK (fy_start_month BETWEEN 1 AND 12),
  plan            TEXT,
  status          TEXT      NOT NULL DEFAULT 'setup'
                  CHECK (status IN ('setup', 'live', 'suspended')),
  settings        JSONB     NOT NULL DEFAULT '{}'::jsonb,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT societies_pincode_format CHECK (pincode ~ '^[0-9]{6}$'),
  CONSTRAINT societies_registration_no_unique UNIQUE (registration_no)
);

COMMENT ON COLUMN societies.fy_start_month IS 'Financial year start month; 4 (April) in India';


-- ---------------------------------------------------------------------
-- 3. towers  — wings / blocks within a society
-- ---------------------------------------------------------------------
CREATE TABLE towers (
  id         BIGSERIAL PRIMARY KEY,
  society_id BIGINT NOT NULL REFERENCES societies (id) ON DELETE CASCADE,
  name       TEXT   NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT towers_name_unique_per_society UNIQUE (society_id, name)
);

CREATE INDEX idx_towers_society ON towers (society_id);


-- ---------------------------------------------------------------------
-- 4. units — individual flats / offices / shops
-- ---------------------------------------------------------------------
CREATE TABLE units (
  id            BIGSERIAL PRIMARY KEY,
  society_id    BIGINT   NOT NULL REFERENCES societies (id) ON DELETE CASCADE,
  tower_id      BIGINT   NOT NULL REFERENCES towers (id)    ON DELETE CASCADE,
  floor         SMALLINT NOT NULL,
  unit_no       TEXT     NOT NULL,
  unit_type     TEXT     NOT NULL,             -- 1BHK / 2BHK / shop / office
  area_sqft     NUMERIC(8, 2) NOT NULL CHECK (area_sqft > 0),
  parking_slots SMALLINT NOT NULL DEFAULT 0 CHECK (parking_slots >= 0),
  status        TEXT     NOT NULL DEFAULT 'vacant'
                CHECK (status IN ('occupied', 'vacant', 'locked')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT units_no_unique_per_tower UNIQUE (society_id, tower_id, unit_no)
);

CREATE INDEX idx_units_society        ON units (society_id);
CREATE INDEX idx_units_society_tower  ON units (society_id, tower_id);
CREATE INDEX idx_units_society_status ON units (society_id, status);

COMMENT ON COLUMN units.society_id IS 'Denormalised from tower for direct tenant scoping';
COMMENT ON COLUMN units.area_sqft  IS 'Basis for per-sqft billing';


-- ---------------------------------------------------------------------
-- 5. files — central file metadata (object-storage keys)
-- Registration uploads the ownership / rent agreement here.
-- ---------------------------------------------------------------------
CREATE TABLE files (
  id          BIGSERIAL PRIMARY KEY,
  society_id  BIGINT NOT NULL REFERENCES societies (id) ON DELETE CASCADE,
  storage_key TEXT   NOT NULL UNIQUE,
  file_name   TEXT   NOT NULL,
  mime        TEXT   NOT NULL,
  size_bytes  BIGINT NOT NULL CHECK (size_bytes > 0),
  uploaded_by BIGINT REFERENCES users (id) ON DELETE SET NULL,
  entity_type TEXT,                            -- polymorphic owner
  entity_id   BIGINT,
  visibility  TEXT   NOT NULL DEFAULT 'owner_only'
              CHECK (visibility IN ('public', 'members', 'committee', 'owner_only')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_files_society ON files (society_id);
CREATE INDEX idx_files_entity  ON files (entity_type, entity_id);


-- ---------------------------------------------------------------------
-- 6. memberships — the heart of access control
-- Permissions always resolve from (user, society, role), never from a
-- global attribute on the user. A self-registered resident starts as
-- 'pending' until an admin approves.
-- ---------------------------------------------------------------------
CREATE TABLE memberships (
  id          BIGSERIAL PRIMARY KEY,
  user_id     BIGINT NOT NULL REFERENCES users     (id) ON DELETE CASCADE,
  society_id  BIGINT NOT NULL REFERENCES societies (id) ON DELETE CASCADE,
  role        TEXT   NOT NULL
              CHECK (role IN ('admin', 'chairman', 'treasurer', 'committee',
                              'owner', 'tenant', 'guard', 'staff', 'accountant')),
  unit_id     BIGINT REFERENCES units (id) ON DELETE SET NULL,
  permissions JSONB,
  status      TEXT   NOT NULL DEFAULT 'pending'
              CHECK (status IN ('pending', 'active', 'rejected', 'ended')),
  approved_by BIGINT REFERENCES users (id) ON DELETE SET NULL,
  start_date  DATE,
  end_date    DATE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- residents are attached to a unit; committee/platform roles are not
  CONSTRAINT memberships_resident_needs_unit
    CHECK (role NOT IN ('owner', 'tenant') OR unit_id IS NOT NULL),
  CONSTRAINT memberships_dates_ordered
    CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

-- one active membership per (user, society, role, unit).
-- unit_id is NULL for committee/platform roles, so it is coalesced — the extra
-- parentheses are required for an expression inside an index column list.
CREATE UNIQUE INDEX idx_memberships_active_unique
  ON memberships (user_id, society_id, role, (COALESCE(unit_id, 0)))
  WHERE status = 'active';

CREATE INDEX idx_memberships_society        ON memberships (society_id);
CREATE INDEX idx_memberships_society_status ON memberships (society_id, status);
CREATE INDEX idx_memberships_user           ON memberships (user_id);
CREATE INDEX idx_memberships_unit           ON memberships (unit_id);

COMMENT ON COLUMN memberships.status IS 'pending = awaiting society-admin approval';


-- ---------------------------------------------------------------------
-- 7. unit_occupancies — ownership and tenancy history per unit
-- The current occupant is the row with a NULL end_date. History is kept so
-- dues liability survives an ownership transfer.
-- ---------------------------------------------------------------------
CREATE TABLE unit_occupancies (
  id              BIGSERIAL PRIMARY KEY,
  unit_id         BIGINT NOT NULL REFERENCES units (id) ON DELETE CASCADE,
  user_id         BIGINT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  occupancy_type  TEXT   NOT NULL CHECK (occupancy_type IN ('owner', 'tenant')),
  agreement_start DATE,
  agreement_end   DATE,
  start_date      DATE   NOT NULL DEFAULT CURRENT_DATE,
  end_date        DATE,
  documents       JSONB  NOT NULL DEFAULT '[]'::jsonb,  -- refs to files.id
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT occupancies_dates_ordered
    CHECK (end_date IS NULL OR end_date >= start_date),
  CONSTRAINT occupancies_agreement_dates_ordered
    CHECK (agreement_end IS NULL OR agreement_start IS NULL
           OR agreement_end >= agreement_start)
);

-- only one current owner per unit at a time
CREATE UNIQUE INDEX idx_occupancies_one_current_owner
  ON unit_occupancies (unit_id)
  WHERE end_date IS NULL AND occupancy_type = 'owner';

CREATE INDEX idx_occupancies_unit ON unit_occupancies (unit_id);
CREATE INDEX idx_occupancies_user ON unit_occupancies (user_id);


-- ---------------------------------------------------------------------
-- updated_at triggers for every table above
-- ---------------------------------------------------------------------
DO $$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'users', 'societies', 'towers', 'units',
    'files', 'memberships', 'unit_occupancies'
  ]
  LOOP
    EXECUTE format(
      'CREATE TRIGGER trg_%1$s_updated_at
         BEFORE UPDATE ON %1$s
         FOR EACH ROW EXECUTE FUNCTION set_updated_at()', t);
  END LOOP;
END;
$$;

COMMIT;
