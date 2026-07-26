# home_screen.dart

Mirrors `lib/features/home/screens/home_screen.dart`.

**Purpose** — the resident dashboard: greeting header, the module grid and a
preview of recent notices.

## What's inside

- `HomeScreen` (StatelessWidget)
- `const` module list (label → route): Billing, Notices, Complaints, Guests,
  **Services**, Staff, Family, Vehicles
- `_HomeHeader` / `_HeaderContent` — flat blue header with a rounded bottom:
  greeting, name, `_FlatBadge` ("Flat 301 • Owner") and an avatar that opens the
  Account tab
- `_ModuleGrid` / `_ModuleTile` — two rows with `spaceBetween`, 64px rounded
  icon tiles
- `_MiniNoticeCard` — notice preview with a left colour accent bar

## Route

`AppRoutes.home` → `/home` (first bottom-nav tab).

## Notes

- Every module tile stays visible so the shape of the product is clear; the
  modules that are not built yet open `EmptyModuleScreen`. Only the Account tab
  has real data today.
- "Services" appears twice on this screen (section heading + module tile); the
  smoke test accounts for that.
