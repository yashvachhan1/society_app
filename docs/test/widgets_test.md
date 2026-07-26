# widgets_test.dart

Mirrors `test/widgets_test.dart`.

**Purpose** — tests for the shared widgets in `lib/core/widgets/`.

## What's inside

- `_host(tester, child)` — helper that centres a widget inside a `MaterialApp`
- `AppCard` — renders its child and fires `onTap`
- `SectionHeader` — renders the title and fires its action
- `StatusChip.forStatus` — renders the label
- `IconChip`, `InfoBanner`, `EmptyState` — render their content

## Notes

Any new widget added to `lib/core/widgets/` should get a case here.
