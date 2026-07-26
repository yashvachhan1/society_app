# models_test.dart

Mirrors `test/models_test.dart`.

**Purpose** — fast unit tests for the domain models and formatters. No widget
tree, so they run in milliseconds.

## What it covers

- `formatRupees` — Indian grouping (`₹ 4,850`, `₹ 1,25,000`, `₹ 0`)
- `AppUser` — `initials` (two names, one name, empty), `hasEmail` (null/blank),
  `copyWith`, default language
- `Membership` — `isPending` / `isActive`, and `isResident` for owner/tenant vs
  committee roles
- `Unit.labelWith` → `"A-402"`, `Society.shortLocation` / `fullAddress`
- `DemoData` consistency — the signed-in membership points at the current unit
  and society, and every demo unit belongs to a known tower

## Notes

When a model gains a derived getter, add its test here — this is the cheapest
coverage in the project.
