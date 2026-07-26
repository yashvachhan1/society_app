# date_field.dart

Mirrors `lib/core/widgets/date_field.dart`.

**Purpose** — inputs for two field types the schema needs: `DATE` columns and
`users.photo_url`.

## What's inside

- `DateField` — labelled, tappable field backed by `showDatePicker`.
  Parameters: `label`, `value`, `onChanged`, `hint`, `helper`, `required`,
  `firstDate`, `lastDate`. Shows the date via `formatDate`, or the hint when
  empty.
- `PhotoAvatar` — round avatar that shows `users.photo_url` when set and the
  user's initials otherwise. `onEdit` adds a camera button; `onLight` styles it
  for a coloured header.

## Used by

Registration (photo, agreement start/end) and the profile header and edit sheet.
