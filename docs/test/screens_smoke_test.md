# screens_smoke_test.dart

Mirrors `test/screens_smoke_test.dart`.

**Purpose** — every screen builds and renders its real data, and the
registration wizard works end to end.

## What's inside

- `_pump(tester, screen)` — hosts a screen in a `MaterialApp` with Google Fonts
  network fetching disabled
- `LanguageScreen` — all three languages are offered
- `HomeScreen` — greeting, flat badge, and the values from the `units` and
  `societies` records (985 sq.ft, 2BHK, the registration number)
- `ProfileScreen` — the `users` columns (phone, email, last login) and the
  `memberships` columns (member since), plus Logout
- `PendingApprovalScreen` — the approval timeline
- **Registration wizard walkthrough** — phone → OTP → name → society → flat →
  proof, asserting each step's title and that upload unlocks submit

## Notes

- "English" appears twice on the language screen (native + English label), so
  that assertion uses `findsWidgets`.
- The data-heavy screens use a tall surface (420×1400/1600) so every card fits
  without scrolling.
