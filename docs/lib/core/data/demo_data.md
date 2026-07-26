# demo_data.dart

Mirrors `lib/core/data/demo_data.dart`.

**Purpose** — placeholder data used while the backend is being built.

## What's inside

- `DemoData.societies` — four societies for the registration picker
  (`societies` table)
- `DemoData.towers` — A / B / C wings (`towers` table)
- `DemoData.units` — five flats with floor, type, area and parking
  (`units` table)
- `DemoData.signedInUser` — the logged-in resident (`users` table)
- `DemoData.currentMembership` — their active owner membership
  (`memberships` table)
- Convenience getters: `currentSociety`, `currentUnit`, `currentTower`

## Used by

Registration wizard, home screen and profile screen.

## Notes

Everything here is replaced by API calls once the backend exists — keep it in
this one file so the swap is a single change. `test/models_test.dart` asserts the
demo records are internally consistent (unit belongs to a known tower, the
membership points at the current unit).
