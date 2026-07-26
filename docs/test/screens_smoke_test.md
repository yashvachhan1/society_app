# screens_smoke_test.dart

Mirrors `test/screens_smoke_test.dart`.

**Purpose** — every screen builds and renders its key content, and the
registration wizard works end to end.

## What's inside

- `_pump(tester, screen)` — hosts a screen with Google Fonts fetching disabled
- `LanguageScreen` — all three languages are offered
- `HomeScreen` — greeting, flat badge, module grid, notices section
- `EmptyModuleScreen` — the "Nothing here yet" placeholder
- `ProfileScreen` — the `users` columns (phone, email, last login) and the
  `memberships` columns (member since), plus Logout
- `PendingApprovalScreen` — the approval timeline
- **Registration wizard walkthrough** — phone → OTP → name → society → flat →
  proof

## Notes

"English" (language screen) and "Services" (home) each appear twice, so those
assertions use `findsWidgets`. The data-heavy screens use a tall test surface.
