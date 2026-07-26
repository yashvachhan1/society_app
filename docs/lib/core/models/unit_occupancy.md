# unit_occupancy.dart

Mirrors `lib/core/models/unit_occupancy.dart`.

**Purpose** — how a person occupies a unit over time. Mirrors the
**`unit_occupancies`** table.

## What's inside

- `UnitOccupancy` — `unitId`, `type` (`OccupancyType`), `agreementStart`,
  `agreementEnd`, `startDate`, `endDate`, `documentIds`
- Derived getters:
  - `isCurrent` — true while `endDate` is null (the occupant in residence)
  - `hasAgreement` — tenants only; owners have no rent agreement
  - `isAgreementExpired(now)` — drives the expiry reminders the admin receives

## Used by

The registration wizard collects `type` and, for tenants, the agreement dates.

## Notes

History is kept rather than overwritten so dues liability survives an ownership
transfer — the current occupant is the row with a null `end_date`.
