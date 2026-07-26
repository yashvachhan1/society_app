# date_field.dart

Mirrors `lib/core/widgets/date_field.dart`.

**Purpose** — inputs for two things the schema needs: `DATE` columns and the
profile photo.

## What's inside

- `DateField` — labelled, tappable field backed by `showDatePicker`.
  Parameters: `label`, `value`, `onChanged`, `hint`, `helper`, `required`,
  `firstDate`, `lastDate`. Shows the date via `formatDate`, or the hint when
  empty.
- `PhotoAvatar` — round avatar showing, in order of preference:
  `photoBytes` (a picture just chosen, via `MemoryImage`), then `photoUrl`
  (a stored `users.photo_url`, via `NetworkImage`), then the user's initials.
  `onEdit` adds a camera button; `onLight` styles it for a coloured header.

## Used by

Registration (photo, agreement start/end) and the profile header.

## Notes

Bytes take priority over the URL so a newly chosen photo appears immediately,
before it has been uploaded.
