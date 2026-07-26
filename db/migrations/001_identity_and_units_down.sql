-- =====================================================================
-- Rollback for migration 001.
-- Drops everything it created, in reverse dependency order.
--
-- WARNING: this deletes all data in these tables. Only use on a
-- development database.
-- =====================================================================

BEGIN;

DROP TABLE IF EXISTS unit_occupancies CASCADE;
DROP TABLE IF EXISTS memberships      CASCADE;
DROP TABLE IF EXISTS files            CASCADE;
DROP TABLE IF EXISTS units            CASCADE;
DROP TABLE IF EXISTS towers           CASCADE;
DROP TABLE IF EXISTS societies        CASCADE;
DROP TABLE IF EXISTS users            CASCADE;

DROP FUNCTION IF EXISTS set_updated_at() CASCADE;

COMMIT;
