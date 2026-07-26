# unit.dart

Mirrors `lib/core/models/unit.dart`.

**Purpose** — the physical structure of a society: wings and flats. Mirrors the
**`towers`** and **`units`** tables.

## What's inside

- `Tower` — `id`, `name` (e.g. "A Wing").
- `UnitStatus` (enum) — `occupied` / `vacant` / `locked`.
- `Unit` — `id`, `towerId`, `floor`, `unitNo`, `unitType` (1BHK/2BHK/shop/
  office), `areaSqft` (basis for per-sqft billing), `parkingSlots`, `status`.
  - `labelWith(tower)` → `"A-402"`
- `OccupancyType` (enum) — `owner` / `tenant`, mirroring
  `unit_occupancies.occupancy_type`; carries a `label` and a `description` used
  on the registration step.

## Used by

The registration wizard (wing + flat pickers) and the home screen. Covered by
`test/models_test.dart`.
