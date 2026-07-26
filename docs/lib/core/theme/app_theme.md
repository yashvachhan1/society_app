# app_theme.dart

Mirrors `lib/core/theme/app_theme.dart`.

**Purpose** — the single source of truth for colours and the Material theme.

## What's inside

- `AppColors` — the whole palette:
  `primary #1565C0`, `primaryLight #1E88E5`, `primaryDark #0D47A1`,
  `accent #00ACC1`, `success #43A047`, `warning #FB8C00`, `error #E53935`,
  `background #F5F7FA`, `surface #FFFFFF`, `textPrimary #1A1A2E`,
  `textSecondary #6B7280`, `divider #E5E7EB`, `cardShadow #1A000000`.
- `AppTheme.lightTheme` — Material 3 theme: seeded colour scheme, Poppins text
  theme (`google_fonts`), app bar style, elevated-button style, input decoration
  (filled, 12px radius, light grey hint) and card style (16px radius).

## Used by

`lib/main.dart` and, through `AppColors`, nearly every widget in the app.

## Notes

- **Never** hardcode a `Color(0x...)` in a feature — use `AppColors`.
- Flat solid colours only; gradients were rejected by the product owner.
- Tinted surfaces use `color.withValues(alpha: 0.12)`.
