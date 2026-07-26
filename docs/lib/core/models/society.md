# society.dart

Mirrors `lib/core/models/society.dart`.

**Purpose** — one tenant society. Mirrors the **`societies`** table.

## What's inside

- `SocietyStatus` (enum) — `setup` / `live` / `suspended`.
- `Society` — `id`, `name`, `registrationNo` (co-op registration number),
  `address`, `city`, `state`, `pincode`, `logoUrl` (nullable), `status`.
  - `shortLocation` → `"Kothrud, Pune"` — the line under the society name
  - `fullAddress` → `"Kothrud, Pune, Maharashtra - 411038"`

## Used by

The registration wizard (society picker) and the home/profile screens. Covered
by `test/models_test.dart`.
