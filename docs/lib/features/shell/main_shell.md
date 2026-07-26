# main_shell.dart

Mirrors `lib/features/shell/main_shell.dart`.

**Purpose** — the persistent bottom navigation bar hosting the signed-in area.

## What's inside

- `MainShell` (StatelessWidget) — renders the active branch above the bar
- `_NavDestination` — private model (icon, active icon, label)
- `_NavItem` — private tab button; the selected icon sits in an
  `AnimatedContainer` pill (icon 30, label 12)
- Four destinations: **Home**, **Payments**, **Notices**, **Account**

## Notes

Material icons only. Payments and Notices open `EmptyModuleScreen` until those
modules are built. Onboarding routes sit outside the shell.
