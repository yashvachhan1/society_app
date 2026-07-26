# main.dart

Mirrors `lib/main.dart`.

**Purpose** — the app's entry point: boots Flutter, applies the theme and
declares every route.

## What's inside

- `main()` → `runApp(const SocietyApp())`; `SocietyApp` is a `MaterialApp.router`
- Routes: `/` splash · `/language` · `/login` · `/register` ·
  `/pending-approval` · `/otp`
- `StatefulShellRoute.indexedStack` → `MainShell` with four branches:
  **Home** `/home`, **Payments** `/billing`, **Notices** `/notices`,
  **Account** `/profile`
- Inside Home: `services`, `complaints`, `guests`, `staff`, `family`,
  `vehicles` — each an `EmptyModuleScreen` for now

## Notes

Onboarding is a straight line: splash → language → login → OTP → shell. New
residents branch to registration, ending at pending approval.
