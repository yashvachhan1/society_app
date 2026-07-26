# language_screen.dart

Mirrors `lib/features/auth/screens/language_screen.dart`.

**Purpose** — the first-run language picker; sets `users.language`.

## What's inside

- `LanguageScreen` (StatefulWidget) — keeps the selected `AppLanguage`.
- `_LanguageOption` — private card showing the native name above the English
  name, with a tick when selected.
- Continue navigates to the login screen.

## Route

`AppRoutes.language` → `/language` (reached from the splash).

## Notes

The product must ship in English, Hindi and Marathi, so this is the first screen
after branding — not a setting buried in the profile. It can be changed later
from Profile → Settings.
