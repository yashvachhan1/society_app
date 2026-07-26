# status_chip.dart

Mirrors `lib/core/widgets/status_chip.dart`.

**Purpose** — a coloured pill for a status word, with the colour chosen for you.

## What's inside

- `StatusChip` (StatelessWidget) — `label`, `color`.
- `StatusChip.forStatus(status)` — convenience constructor that picks the colour
  from the status text.
- `StatusChip.colorForStatus(String status)` (static) — the mapping, case
  insensitive:
  - `error` — Urgent, Absent, Overdue-style states
  - `success` — Completed, Present, Paid
  - `warning` — In Progress, Pending
  - `primary` — Submitted
  - `accent` — Events
  - `textSecondary` — anything unknown (safe fallback)

## Used by

Complaints, staff, guests, billing and notices lists.

## Notes

Add a new status to `colorForStatus` rather than passing a raw colour, so the
same word always looks the same. Covered by `test/models_test.dart`.
