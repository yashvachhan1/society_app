# screens_smoke_test.dart

Mirrors `test/screens_smoke_test.dart`.

**Purpose** — every screen builds and renders its real data, and the
registration wizard works end to end.

## What's inside

- `_pump(tester, screen)` — hosts a screen in a `MaterialApp` with Google Fonts
  network fetching disabled
- `LanguageScreen` — all three languages are offered
- `HomeScreen` — the header values from `users` / `memberships` / `units`, plus
  proof that the old module grid and notices are gone
- `EmptyModuleScreen` — the "Nothing here yet" placeholder
- `ProfileScreen` — the `users` columns (phone, email, last login) and the
  `memberships` columns (member since), plus Logout
- `PendingApprovalScreen` — the approval timeline
- **Registration walkthrough** — phone → OTP → name → society → flat → proof
- **Tenant agreement** — switching occupancy to Tenant reveals
  `agreement_start` / `agreement_end`; an owner never sees them

## Notes

- "English" appears twice on the language screen (native + English label), so
  that assertion uses `findsWidgets`.
- Data-heavy screens use a tall surface (420×1400/1600) so every card fits.
