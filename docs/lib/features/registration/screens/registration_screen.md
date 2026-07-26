# registration_screen.dart

Mirrors `lib/features/registration/screens/registration_screen.dart`.

**Purpose** — resident self-registration (requirement R4.1.5). The resident
picks their society and flat, uploads proof, and waits for admin approval.

## The five steps

| Step | Table | Fields collected |
|---|---|---|
| 1 Verify | `users` | `phone` + OTP |
| 2 About you | `users` | `name`, `email`, `language` |
| 3 Society | `societies` | which society |
| 4 Your flat | `units`, `unit_occupancies` | wing, flat, owner/tenant |
| 5 Proof | `files` | ownership or rent agreement |

Submitting creates a `memberships` row with `status = 'pending'` and routes to
the pending-approval screen.

## What's inside

- `RegistrationScreen` (StatefulWidget) — holds every field plus `_step`.
  - `_canContinue` — per-step validation that enables the Continue button
  - listeners on the phone, OTP and name controllers so the button reacts as the
    user types
- `_StepBar` — "Step N of 5" with a segmented progress bar
- `_StepIntro` — the title + explanation at the top of each step
- `_UploadBox` — empty upload target, or the picked file with a remove action
- `_ReviewSummary` / `_SummaryLine` — the recap shown on the last step
- `_Footer` — the sticky Continue / "Submit for approval" button

## Route

`AppRoutes.register` → `/register` (from the login screen's "Create an account").

## Notes

- The phone number becomes the account identity and cannot be changed later —
  the helper text says so.
- The proof document is visible only to the resident and the society admin.
- OTP is simulated in this build; the real one must be single-use, short-lived
  and rate-limited.
