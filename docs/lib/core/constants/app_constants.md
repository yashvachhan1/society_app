# app_constants.dart

Mirrors `lib/core/constants/app_constants.dart`.

**Purpose** — app-wide constants: the name/version and every route path.

## What's inside

- `AppConstants` — `appName` ("Society App"), `appVersion`.
- `AppRoutes`:
  - Onboarding: `splash` `/`, `language` `/language`, `register` `/register`,
    `login` `/login`, `otp` `/otp`, `pendingApproval` `/pending-approval`
  - Bottom-nav tabs: `home` `/home`, `billing` `/billing`, `notices` `/notices`,
    `profile` `/profile`

## Used by

`lib/main.dart` (route table) and any screen that navigates.

## Notes

Never write a route string inline — add a constant here first, otherwise a typo
becomes a silent dead link. The old `/home/...` module routes were removed with
the home grid; they come back with their features.
