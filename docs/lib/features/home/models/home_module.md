# home_module.dart

Mirrors `lib/features/home/models/home_module.dart`.

**Purpose** — one tile in the home screen's module grid.

## What's inside

- `HomeModule` — `icon`, `label`, `color`, `route`.

## Used by

`home_screen.dart` — the eight tiles.

## Notes

Each tile carries the route it opens; unbuilt modules point at
`EmptyModuleScreen`. When services become modular per society, this list will be
filtered by the society's enabled modules.
