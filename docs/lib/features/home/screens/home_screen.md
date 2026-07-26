# home_screen.dart

Mirrors `lib/features/home/screens/home_screen.dart`.

**Purpose** — the resident's dashboard. Every value comes from a database
record: the signed-in `users` row, their `memberships` row, and the `units`,
`towers` and `societies` rows those point at.

## What's inside

- `HomeScreen` (StatelessWidget)
- `_HomeHeader` — blue header with a rounded bottom: greeting, the user's name,
  a `_FlatBadge` ("A-402 • Owner") and an avatar with their initials that opens
  the Account tab
- `_FlatCard` — the `units` row: flat number, wing, floor, unit type, carpet
  area, parking slots
- `_SocietyCard` — the `societies` row: name, registration number, full address
- `_MembershipCard` — the `memberships` row: role, status, member since

## Route

`AppRoutes.home` → `/home` (first bottom-nav tab).

## Notes

The module grid and the sample notices were removed — nothing on this screen is
invented; each row maps to a column that exists in the schema. Modules return
with their features.
