# labelled_field.dart

Mirrors `lib/core/widgets/labelled_field.dart`.

**Purpose** — the form building blocks, so every form in the app looks the same.

## What's inside

- `FieldLabel` — a form label with an optional red `*` when `required` is set.
- `LabelledField` — label + text input + optional helper line.
  Parameters: `label`, `controller`, `hint`, `helper`, `required`,
  `keyboardType`, `maxLength`, `prefix`, `maxLines`.
- `ChoiceChipTile` — a selectable pill (used for language, wing, unit type).
- `SelectableTile` — a card-style option row with title, subtitle, optional
  leading icon and a tick when selected (used for society, flat and occupancy
  pickers).

## Used by

The registration wizard and the profile edit sheet.

## Notes

`helper` is where the field's meaning goes ("Use the name as printed on your
agreement") — it keeps forms understandable for non-technical residents.
