# Database

PostgreSQL schema for the Society Management Platform, taken from
`Society-Management-Platform-DB-Schema-v1.0 (1).docx`.

## What is here

```
db/
├── migrations/
│   ├── 001_identity_and_units.sql        create the tables
│   └── 001_identity_and_units_down.sql   rollback (drops them)
└── seed/
    └── demo_data.sql                     demo rows matching the app
```

Migration 001 creates only what today's app flow needs —
**registration → login → dashboard**:

| Table | What it holds |
|---|---|
| `users` | one row per person; `phone` is the login (OTP) |
| `societies` | one row per tenant society |
| `towers` | wings / blocks inside a society |
| `units` | flats: number, floor, type, area, parking |
| `files` | uploaded documents (the registration proof) |
| `memberships` | **(user, society, role)** — the heart of access control |
| `unit_occupancies` | owner / tenant history per unit |

Billing, accounting, complaints, amenities, gate, meetings and the rest of the
schema arrive in later migrations, when those modules are built.

## Run it in pgAdmin

1. Open **pgAdmin** and connect to your server (it remembers your password).
2. Right-click **Databases → Create → Database…**
   - **Database:** `society_db`
   - Save.
3. Click the new `society_db`, then the **Query Tool** button (⚡ icon).
4. Open `db/migrations/001_identity_and_units.sql`, copy everything, paste it
   into the Query Tool, and press **F5** (Execute).
   You should see `Query returned successfully`.
5. Optional demo rows: do the same with `db/seed/demo_data.sql`. The last
   statement prints the resident, their society, wing, flat and role — the exact
   record the app's dashboard shows.
6. Check the tables: expand **society_db → Schemas → public → Tables**.
   Seven tables should be listed.

> Make sure the Query Tool title bar says **society_db**, not `postgres` —
> otherwise the tables land in the wrong database.

## Run it from a terminal instead

```bash
psql -U postgres -c "CREATE DATABASE society_db;"
```

```bash
psql -U postgres -d society_db -f db/migrations/001_identity_and_units.sql
```

```bash
psql -U postgres -d society_db -f db/seed/demo_data.sql
```

## Starting over

Running the migration twice fails with "relation already exists" — that is
expected. To reset a development database, run
`db/migrations/001_identity_and_units_down.sql` first, then the migration again.
The seed script is safe to re-run at any time.

## Conventions

From the schema document, and enforced in every table here:

- `id BIGSERIAL` primary keys; every foreign key is indexed
- Every tenant-scoped table carries `society_id`, and composite indexes lead
  with it — that is the filter on every query
- `created_at` / `updated_at TIMESTAMPTZ` everywhere, kept current by a trigger
- Money is `NUMERIC(12,2)` — never a float
- Enumerations are `TEXT` + a `CHECK` constraint, so adding a value is a small
  migration rather than a type change
- Phone numbers are stored normalised (`+919876543210`); the app formats them
  for display

## Rules to keep

- **Never edit a migration that has been run.** Write a new numbered one.
- Seed and demo data live in `db/seed/`, never inside a migration.
- Every query in the backend must filter by `society_id` from the authenticated
  token — see the `api-security` skill.
