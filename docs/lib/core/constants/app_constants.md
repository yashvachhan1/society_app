# app_constants.dart

Mirrors `lib/core/constants/app_constants.dart`.

**Purpose** — app-wide constants: the name/version and every route path.

## What's inside

- `AppConstants` — `appName`, `appVersion`.
- `AppRoutes`:
  - Onboarding: `splash` `/`, `language`, `register`, `login`, `otp`,
    `pendingApproval`
  - Bottom-nav tabs: `home`, `billing`, `notices`, `profile`
  - Home-grid modules (inside the Home tab): `services`, `complaints`,
    `guests`, `staff`, `family`, `vehicles`

## Notes

Never write a route string inline. Module routes currently resolve to
`EmptyModuleScreen`.
