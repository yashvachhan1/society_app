# empty_state.dart

Mirrors `lib/core/widgets/empty_state.dart`.

**Purpose** — the friendly "nothing here yet" placeholder.

## What's inside

- `EmptyState` (StatelessWidget)
  - `icon` — a large tinted icon in a rounded square
  - `title` — the main line
  - `message` — optional supporting line

## Used by

`notices_screen.dart` when a filter matches nothing; use it on any list that can
be empty.

## Notes

Never leave a blank area when a list is empty — always show this.
