# registration_screen.dart

Mirrors `lib/features/registration/screens/registration_screen.dart`.

**Purpose** — resident self-registration (requirement R4.1.5). Collects every
column the resident is responsible for, then waits for admin approval.

## The five steps and the columns they fill

| Step | Table | Fields collected |
|---|---|---|
| 1 Verify | `users` | `phone` + OTP |
| 2 About you | `users` | `photo_url`, `name`, `email`, `language` |
| 3 Society | `memberships` | which `society_id` |
| 4 Your flat | `units`, `unit_occupancies` | wing, `unit_id`, `occupancy_type`, and for tenants `agreement_start` / `agreement_end` |
| 5 Proof | `files` | ownership or rent agreement |

Submitting creates a `memberships` row with `status = 'pending'`.

## What's inside

- `RegistrationScreen` (StatefulWidget) — every field plus `_step`
  - `_canContinue` — per-step validation; tenants cannot continue without both
    agreement dates
  - controller listeners so the button reacts as the user types
  - `_initialsFrom(name)` — live initials for the photo avatar
- `_StepBar` · `_StepIntro` · `_UploadBox` · `_ReviewSummary` / `_SummaryLine` ·
  `_Footer`

## Route

`AppRoutes.register` → `/register`.

## Notes

- The phone number becomes the account identity and cannot be changed later.
- Agreement dates apply to **tenants only** — owners have no rent agreement.
- The society's own details (name, registration number, logo) are read-only
  here; they are created by the platform/society admin, not the resident.
