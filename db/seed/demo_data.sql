-- =====================================================================
-- Demo data — mirrors lib/core/data/demo_data.dart so the app and the
-- database show the same records while the API is being built.
--
-- Safe to re-run: every insert is idempotent.
-- Run AFTER db/migrations/001_identity_and_units.sql
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- Societies (the four a resident can pick during registration)
-- ---------------------------------------------------------------------
INSERT INTO societies (name, registration_no, address, city, state, pincode, status)
VALUES
  ('Sunrise Residency',    'PNE/CO-OP/2015/4821', 'Kothrud',    'Pune',      'Maharashtra', '411038', 'live'),
  ('Green Valley Heights', 'MUM/CO-OP/2012/1190', 'Powai',      'Mumbai',    'Maharashtra', '400076', 'live'),
  ('Palm Meadows',         'PNE/CO-OP/2018/7734', 'Baner',      'Pune',      'Maharashtra', '411045', 'live'),
  ('Lake View Towers',     'BLR/CO-OP/2016/2287', 'Whitefield', 'Bengaluru', 'Karnataka',   '560066', 'live')
ON CONFLICT (registration_no) DO NOTHING;

-- ---------------------------------------------------------------------
-- Towers of Sunrise Residency
-- ---------------------------------------------------------------------
INSERT INTO towers (society_id, name)
SELECT s.id, w.name
FROM societies s
CROSS JOIN (VALUES ('A Wing'), ('B Wing'), ('C Wing')) AS w(name)
WHERE s.registration_no = 'PNE/CO-OP/2015/4821'
ON CONFLICT (society_id, name) DO NOTHING;

-- ---------------------------------------------------------------------
-- Units
-- ---------------------------------------------------------------------
INSERT INTO units (society_id, tower_id, floor, unit_no, unit_type, area_sqft, parking_slots, status)
SELECT t.society_id, t.id, u.floor, u.unit_no, u.unit_type, u.area_sqft, u.parking_slots, u.status
FROM towers t
JOIN societies s ON s.id = t.society_id AND s.registration_no = 'PNE/CO-OP/2015/4821'
JOIN (VALUES
    ('A Wing', 4, '402', '2BHK',  985.00, 1, 'occupied'),
    ('A Wing', 2, '204', '1BHK',  640.00, 1, 'vacant'),
    ('B Wing', 1, '101', '3BHK', 1320.00, 2, 'vacant'),
    ('B Wing', 7, '703', '2BHK', 1010.00, 1, 'vacant'),
    ('C Wing', 3, '305', '2BHK',  995.00, 1, 'vacant')
  ) AS u(tower_name, floor, unit_no, unit_type, area_sqft, parking_slots, status)
  ON u.tower_name = t.name
ON CONFLICT (society_id, tower_id, unit_no) DO NOTHING;

-- ---------------------------------------------------------------------
-- The signed-in resident
-- ---------------------------------------------------------------------
INSERT INTO users (phone, name, email, language, status, last_login_at)
VALUES ('+919876543210', 'Rahul Sharma', 'rahul.sharma@email.com', 'en', 'active', now())
ON CONFLICT (phone) DO NOTHING;

-- ---------------------------------------------------------------------
-- His membership: owner of A Wing 402, approved and active
-- ---------------------------------------------------------------------
INSERT INTO memberships (user_id, society_id, role, unit_id, status, start_date)
SELECT u.id, un.society_id, 'owner', un.id, 'active', DATE '2024-01-15'
FROM users u
JOIN societies s ON s.registration_no = 'PNE/CO-OP/2015/4821'
JOIN towers   t  ON t.society_id = s.id AND t.name = 'A Wing'
JOIN units    un ON un.tower_id = t.id AND un.unit_no = '402'
WHERE u.phone = '+919876543210'
  AND NOT EXISTS (
    SELECT 1 FROM memberships m
    WHERE m.user_id = u.id AND m.society_id = un.society_id
      AND m.role = 'owner' AND m.unit_id = un.id
  );

-- ---------------------------------------------------------------------
-- The matching occupancy record (owner, still living there)
-- ---------------------------------------------------------------------
INSERT INTO unit_occupancies (unit_id, user_id, occupancy_type, start_date)
SELECT un.id, u.id, 'owner', DATE '2024-01-15'
FROM users u
JOIN societies s ON s.registration_no = 'PNE/CO-OP/2015/4821'
JOIN towers   t  ON t.society_id = s.id AND t.name = 'A Wing'
JOIN units    un ON un.tower_id = t.id AND un.unit_no = '402'
WHERE u.phone = '+919876543210'
  AND NOT EXISTS (
    SELECT 1 FROM unit_occupancies o
    WHERE o.unit_id = un.id AND o.end_date IS NULL AND o.occupancy_type = 'owner'
  );

COMMIT;

-- ---------------------------------------------------------------------
-- What the app's dashboard reads — run this to check the seed worked
-- ---------------------------------------------------------------------
SELECT u.name,
       u.phone,
       u.email,
       s.name            AS society,
       t.name            AS wing,
       un.unit_no,
       un.unit_type,
       un.area_sqft,
       un.parking_slots,
       m.role,
       m.status,
       m.start_date
FROM memberships m
JOIN users     u  ON u.id  = m.user_id
JOIN societies s  ON s.id  = m.society_id
JOIN units     un ON un.id = m.unit_id
JOIN towers    t  ON t.id  = un.tower_id
WHERE u.phone = '+919876543210';
