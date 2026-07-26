---
name: flutter-screen
description: The workflow for building or changing a screen in this Flutter app — where files go, routing through go_router and the bottom-nav shell, which shared pieces to reuse, states, and the analyze/test/screenshot verification loop. Load before creating a new screen, feature or major widget.
---

# Building a screen

Pair this with the `design-system` skill (visual rules) and `code-quality`
(the gate it must pass).

## Where things live

Feature-first, one folder per feature:

```
lib/features/<feature>/
├── models/<thing>.dart      typed model — never Map<String, dynamic>
├── screens/<x>_screen.dart
└── widgets/                 only if used by 2+ screens in this feature
```

If a widget would be useful outside the feature, it belongs in
`lib/core/widgets/` instead.

## Routing

Route constants live in `lib/core/constants/app_constants.dart` (`AppRoutes`)
and are registered in `lib/main.dart` with `go_router`.

The app uses `StatefulShellRoute.indexedStack` for the bottom nav (Home,
Payments, Notices, Account). A screen pushed **inside** a tab keeps the bottom
bar visible — put it under that branch as a sub-route:

```dart
GoRoute(path: 'services', builder: (_, _) => const ServicesScreen()),
// reached as AppRoutes.services == '/home/services'
```

Add the constant first, then the route, then link it from the home grid.

## Structure of a screen

- Compose from `lib/core/widgets/` (`AppCard`, `SectionHeader`, `StatusChip`,
  `InfoBanner`, `EmptyState`, `IconChip`) — don't hand-roll containers that
  already exist.
- Split the build into small private widgets (`_Header`, `_FilterBar`, `_Card`)
  rather than one long `build`.
- Local UI state → `StatefulWidget` + `setState`, kept in the screen that owns
  it. Dispose every `TextEditingController`.
- Bottom sheets for quick actions (see the booking sheet in `services`).

## Data

Use typed models with derived getters (`isPresent`, `statusIcon`,
`attendanceFraction`) so widgets stay dumb. While the backend is unbuilt, keep
placeholder data as `const` lists near the screen so it is obvious what will
come from the API later — never scatter literals through the widget tree.

## States

Loading (shimmer/skeleton), empty (`EmptyState`), error (message + retry). No
blank white flash between states.

## Verify before showing the user

1. `C:/flutter/bin/flutter.bat analyze` → **No issues found!**
2. `C:/flutter/bin/flutter.bat test` → all pass, and add a smoke test for the
   new screen in `test/screens_smoke_test.dart` (render it, assert its title).
3. Look at it: `flutter build web --release`, serve `build/web`
   (`.claude/launch.json` → `web-static`) and screenshot at phone width. Check
   for overflow and mid-word wrapping (`Total Reside nts` = broken).
4. Screenshot tip: to capture a specific tab/step, temporarily change the
   initial route/index, build, screenshot — then **revert the temp change**.
   Synthetic clicks on the Flutter canvas are unreliable; this is dependable.

## Device notes

- The user previews on their phone over LAN:
  `flutter run --release -d web-server --web-hostname 0.0.0.0 --web-port 5000`,
  then `<PC-LAN-IP>:5000` in an **incognito** tab (avoids stale cache).
- Impeller is disabled in `AndroidManifest.xml` — required for their Vivo
  device, do not remove it.

## Then

Report what changed and show the screenshot. **Never run `git commit` or
`git push`** — give the user the command to run. They prefer one polished
screen at a time.
