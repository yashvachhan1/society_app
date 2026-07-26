# icon_detail_row.dart

Mirrors `lib/core/widgets/icon_detail_row.dart`.

**Purpose** — the app's standard way of displaying a field read from the
backend: a tinted icon square, a small label and the value.

## What's inside

- `IconDetailRow` — `icon`, `label`, `value`, `color`, `isPlaceholder`
  (greys the value for empty fields such as "Not added").
- `DetailCard` — a titled white card holding a list of `IconDetailRow`s with
  dividers between them (the "Account Details" / "Flat Details" block).

## Used by

`home_screen.dart` (flat, society and membership cards) and
`profile_screen.dart` (account and membership cards).

## Notes

Both screens share these two widgets rather than each building their own rows —
that is what keeps the duplication score at zero.
