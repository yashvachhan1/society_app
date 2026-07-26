---
name: db-schema
description: PostgreSQL rules for this platform — multi-tenant table design, naming, keys, indexes, money and timestamps, migrations, and the core schema (properties, units, users, modules, bills, complaints, tickets). Load before creating or altering any table, writing a migration, or designing a query.
---

# PostgreSQL schema rules

One database, many properties (tenants). Isolation is enforced by a
`property_id` column plus disciplined queries — see `api-security`.

## Naming

- Tables plural `snake_case`: `properties`, `property_units`, `maintenance_bills`
- Columns `snake_case`; primary key `id`; foreign key `<table_singular>_id`
- Booleans read as a fact: `is_active`, `is_paid`
- Timestamps `*_at`; no ambiguous `date`/`time` names
- No reserved words (`user` → `users`, `order` → `orders`)

## Every table gets

```sql
id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
created_at   timestamptz NOT NULL DEFAULT now(),
updated_at   timestamptz NOT NULL DEFAULT now()
```

Every **tenant-owned** table also gets:

```sql
property_id  uuid NOT NULL REFERENCES properties(id) ON DELETE CASCADE
```

and an index on it (queries always filter by it):

```sql
CREATE INDEX idx_bills_property ON bills (property_id);
CREATE INDEX idx_bills_property_status ON bills (property_id, status);
```

Compound indexes start with `property_id` — that is the leading filter in every
query. Unique constraints are scoped too:
`UNIQUE (property_id, unit_number)`, never `UNIQUE (unit_number)`.

## Types

- Ids: `uuid` (never sequential integers — they leak counts and are guessable)
- **Money: `numeric(12,2)`. Never `float`/`double`.** Store rupees, not paise,
  and format for display with `formatRupees` in the Flutter apps.
- Time: `timestamptz` (UTC), never naive `timestamp`
- Short enums: `text` + a `CHECK` constraint (easier to extend than PG enums)
  e.g. `status text NOT NULL CHECK (status IN ('open','in_progress','resolved'))`
- Free-form extras: `jsonb` — but never for data you filter or join on
- Phone/email: `text` with a `CHECK`, phone stored normalized (`+91XXXXXXXXXX`)

## Integrity

- Declare every foreign key with an explicit `ON DELETE` (`CASCADE` for rows
  that belong to a property, `RESTRICT` where deletion should be blocked).
- `NOT NULL` by default; make nullability a deliberate choice.
- Soft-delete only where history matters (`deleted_at timestamptz`); then every
  read filters `deleted_at IS NULL`. Otherwise delete for real.

## Core schema sketch

```
properties         id, name, type, city, address, status, plan, is_custom_plan,
                   created_at, updated_at
property_modules   property_id, module_key, is_enabled          -- modular services
property_towers    property_id, name, floors
property_units     property_id, tower_id, unit_number, floor, type
users              id, phone, email, password_hash, name, role, created_at
property_members   property_id, user_id, unit_id, role, relation, is_active
maintenance_bills  property_id, unit_id, period, amount, due_date, status
payments           property_id, bill_id, gateway_payment_id UNIQUE, amount, status
complaints         property_id, unit_id, category, priority, status, description
notices            property_id, title, body, published_at
visitors           property_id, unit_id, name, phone, purpose, entry_at, exit_at
support_tickets    property_id, user_id, category, priority, status, subject
```

`property_modules` is what makes services modular: the backend reads it to allow
or reject a module, and the apps read it to show or hide a feature.
`users` is global (a person can belong to more than one property);
`property_members` is the tenant-scoped join that carries their role there.

## Migrations

- Every schema change is a migration file, ordered and committed —
  never an ad-hoc `ALTER` run by hand.
- Name them `NNN_verb_object.sql` (`003_add_property_modules.sql`).
- Migrations are **append-only**: to fix something, write a new migration.
- Each has a matching `down` where reversal is possible.
- Adding a `NOT NULL` column to a live table: add nullable → backfill → set
  `NOT NULL`, in separate steps.
- Seed/demo data lives in a seed script, never inside a migration.

## Query habits

- `SELECT` the columns you need, not `SELECT *`, in application code.
- Filter by `property_id` **first** in every `WHERE`.
- Paginate with `LIMIT/OFFSET` (or keyset for big tables); never fetch a whole
  table into Node and slice it there.
- Check `EXPLAIN` when a list query starts feeling slow — a missing
  `(property_id, ...)` index is usually the cause.
