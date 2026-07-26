# home_screen.dart

Mirrors `lib/features/home/screens/home_screen.dart`.

**Purpose** — the resident's home tab: who is signed in and which flat they
belong to. Everything below the header is intentionally empty.

## What's inside

- `HomeScreen` (StatelessWidget)
- `_HomeHeader` / `_HeaderContent` — blue header with a rounded bottom:
  greeting, the user's name (`users.name`), a `_FlatBadge`
  ("A-402 • Owner", from `units` + `towers` + `memberships`) and a
  `PhotoAvatar` (`users.photo_url`, initials fallback) that opens the Account tab
- `_FlatBadge` — the white pill under the name
- An `EmptyState` — "Nothing here yet"

## Route

`AppRoutes.home` → `/home` (first bottom-nav tab).

## Notes

The module grid and the sample notices were removed on purpose: those modules
do not exist yet, and nothing is shown that the backend cannot provide. The
resident's real data lives on the Account tab. Modules return with their
features.
