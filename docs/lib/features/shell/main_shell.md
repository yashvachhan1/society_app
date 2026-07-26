# main_shell.dart

Mirrors `lib/features/shell/main_shell.dart`.

**Purpose** — the persistent bottom navigation bar hosting the signed-in area.

## What's inside

- `MainShell` (StatelessWidget) — takes the `navigationShell` from
  `StatefulShellRoute` and renders the active branch above the bar
- `_NavDestination` — private model (icon, active icon, label)
- `_NavItem` — private tab button; the selected icon sits in an
  `AnimatedContainer` pill (icon 30, label 12)
- `_onTap(index)` — switches branch, keeping each tab's own stack
- Two destinations: **Home** and **Account**

## Used by

`lib/main.dart` as the shell builder.

## Notes

Material icons only — an Iconsax variant was tried and rejected. More tabs
(Payments, Notices) return when those modules are built. Onboarding routes sit
outside the shell, so the bar is hidden there.
