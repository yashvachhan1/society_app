---
name: db-schema
description: PostgreSQL rules for this platform — multi-tenant table design, naming, keys, indexes, money and timestamps, migrations, and which tables exist today. Load before creating or altering any table, writing a migration, or designing a query.
---

# PostgreSQL schema rules

The authoritative spec is **`Society-Management-Platform-DB-Schema-v1.0 (1).docx`**
at the repo root. Follow it — do not invent names. The live SQL lives in `db/`.

One database, many societies (tenants). Isolation comes from a `society_id`
column plus disciplined queries — see `api-security`.

## What exists today

`db/migrations/001_identity_and_units.sql` creates the tables the current app
flow (registration → login → dashboard) needs:

`users` · `societies` · `towers` · `units` · `files` · `memberships` ·
`unit_occupancies`

The document defines ~45 tables in total. The rest (billing, accounting,
communication, helpdesk, amenities, staff, gate, meetings, notifications) get
their own numbered migrations when those modules are built. Do not create a
table before its feature.

## Naming

- Tables plural `snake_case`: `societies`, `unit_occupancies`, `journal_lines`
- Columns `snake_case`; primary key `id`; foreign key `<table_singular>_id`
- Timestamps `*_at`; dates `*_date` / `*_on`
- No reserved words (`user` → `users`)

## Every table gets

```sql
id         BIGSERIAL PRIMARY KEY,
created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
```

`updated_at` is maintained by the shared `set_updated_at()` trigger — attach it
to every new table.

Every **tenant-scoped** table also gets:

```sql
society_id BIGINT NOT NULL REFERENCES societies (id) ON DELETE CASCADE
```

with an index, because every query filters on it:

```sql
CREATE INDEX idx_units_society        ON units (society_id);
CREATE INDEX idx_units_society_status ON units (society_id, status);
```

Composite indexes **lead with `society_id`**. Unique constraints are scoped the
same way: `UNIQUE (society_id, tower_id, unit_no)`, never `UNIQUE (unit_no)`.

## Types

- Ids: `BIGSERIAL` (per the schema document)
- **Money: `NUMERIC(12,2)`. Never `float`/`double`.** Rupees, not paise.
- Rates/percentages: `NUMERIC(8,4)`
- Time: `TIMESTAMPTZ` (UTC), never naive `timestamp`
- Enums: `TEXT` + a `CHECK` constraint — adding a value is then a small
  migration instead of a type change:
  `status TEXT NOT NULL CHECK (status IN ('pending','active','rejected','ended'))`
- Flexible config only: `jsonb` (feature-flag config, notification payloads) —
  never for data you filter or join on
- Phone: `VARCHAR(15)`, stored normalised `+919876543210`, with a format `CHECK`

## Integrity

- Every foreign key declares `ON DELETE` explicitly — `CASCADE` for rows that
  belong to a society, `SET NULL` for optional references (`approved_by`).
- `NOT NULL` by default; nullability is a deliberate decision.
- Financial tables are append-oriented: corrections are **reversing entries**,
  never updates or deletes.
- Use partial unique indexes for "only one current X" rules, e.g. one active
  membership per (user, society, role, unit), one current owner per unit.

## Key relationships to respect

- `users` 1–N `memberships` N–1 `societies` — permissions **always** resolve
  from a membership, never from a global flag on the user. The auditor
  provision is simply several `accountant` memberships for one user.
- `units` 1–N `unit_occupancies` — the current occupant is the row with a NULL
  `end_date`; history is kept so dues liability survives an ownership transfer.
- A self-registered resident's membership starts at `status = 'pending'` until a
  society admin approves it.

## Migrations

- Every schema change is a numbered file in `db/migrations/`, committed —
  never an ad-hoc `ALTER` typed into pgAdmin.
- Name them `NNN_verb_object.sql`, with a matching `NNN_..._down.sql`.
- Migrations are **append-only**: to fix something, write a new one. Never edit
  a migration that has already been run.
- Adding a `NOT NULL` column to a live table: add nullable → backfill → set
  `NOT NULL`, in separate steps.
- Seed/demo data lives in `db/seed/`, never inside a migration, and must be
  safe to re-run (`ON CONFLICT DO NOTHING` or a `NOT EXISTS` guard).

## Query habits

- `SELECT` the columns you need, not `SELECT *`.
- Filter by `society_id` **first** in every `WHERE`, taken from the
  authenticated token — never from the request body.
- Paginate lists; never fetch a table into Node and slice it there.
- Reach for `EXPLAIN` when a list query slows down — a missing
  `(society_id, …)` index is usually the cause.
