# main.dart

Mirrors `lib/main.dart`.

**Purpose** — the app's entry point: boots Flutter, applies the theme and
declares every route.

## What's inside

- `main()` — calls `runApp(const SocietyApp())`.
- `SocietyApp` — `MaterialApp.router` wired with `AppTheme.lightTheme`.
- `GoRouter` configuration:
  - `/` → `SplashScreen` · `/language` → `LanguageScreen`
  - `/login` → `LoginScreen` · `/register` → `RegistrationScreen`
  - `/pending-approval` → `PendingApprovalScreen`
  - `/otp` → `OtpScreen` (phone passed via `extra`)
  - `StatefulShellRoute.indexedStack` → `MainShell` with four branches:
    **Home** `/home`, **Payments** `/billing`, **Notices** `/notices`,
    **Account** `/profile`

## Notes

Onboarding is a straight line: splash → language → login → OTP → shell. New
residents branch to registration, which ends at pending approval.

Only the Account tab holds real data. Home shows the resident header and an
empty state; Payments and Notices open `EmptyModuleScreen` until those modules
are built.

To add a screen: constant in `AppRoutes` → route here → link it from the UI.
