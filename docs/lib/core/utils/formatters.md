# formatters.dart

Mirrors `lib/core/utils/formatters.dart`.

**Purpose** — display formatting helpers, so the same value always looks the
same across screens.

## What's inside

- `kNoValue` — the `—` placeholder shown for a null field
- `formatRupees(num)` → `₹ 4,850` / `₹ 1,25,000` (Indian grouping, `intl`)
- `formatDate(DateTime?)` → `15 Jan 2024`, or `—` when null. For nullable `DATE`
  columns such as `memberships.start_date`
- `formatDateTime(DateTime?)` → `26 Jul 2026, 09:15`, or `—`. For `TIMESTAMPTZ`
  columns such as `users.last_login_at`

## Used by

Home and profile screens. Covered by `test/models_test.dart`.
