# section_header.dart

Mirrors `lib/core/widgets/section_header.dart`.

**Purpose** — a section title with an optional action link on the right.

## What's inside

- `SectionHeader` (StatelessWidget)
  - `title` — the heading text
  - `actionLabel` — optional trailing text button (e.g. "View all")
  - `onAction` — callback for that button

## Used by

Every screen that splits content into sections.

## Notes

Covered by `test/widgets_test.dart` (asserts the action fires).
