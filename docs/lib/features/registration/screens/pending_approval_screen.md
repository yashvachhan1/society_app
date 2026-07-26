# pending_approval_screen.dart

Mirrors `lib/features/registration/screens/pending_approval_screen.dart`.

**Purpose** — what the resident sees after submitting registration, while
`memberships.status` is still `pending`.

## What's inside

- `PendingApprovalScreen` (StatelessWidget)
- A three-step timeline: **Request submitted** (done) → **Admin review**
  (active) → **Account activated** (upcoming)
- `_ApprovalStep` — private model for one timeline entry
- `_StepRow` — private row with the status dot and the connecting line
- A note that a notification will arrive, and a "Back to login" action

## Route

`AppRoutes.pendingApproval` → `/pending-approval`.

## Notes

Approval is a real gate, not a formality: the society admin verifies the flat
and the uploaded proof before the account becomes usable.
