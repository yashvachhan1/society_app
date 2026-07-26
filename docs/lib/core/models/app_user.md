# app_user.dart

Mirrors `lib/core/models/app_user.dart`.

**Purpose** — the signed-in person. One record per human, no matter how many
societies they belong to. Mirrors the **`users`** table.

## What's inside

- `AppLanguage` (enum) — `en` / `hi` / `mr`, mirroring `users.language`. Each
  value carries `code` (stored in the DB), `label` (English name) and
  `nativeLabel` (`English`, `हिंदी`, `मराठी`).
- `UserStatus` (enum) — `active` / `blocked`, mirroring `users.status`.
- `AppUser` — `phone` (unique, the login identifier), `name`, `email` (nullable),
  `photoUrl` (nullable), `language`, `status`, `lastLoginAt`.
  - `initials` — up to two letters for the avatar ("Rahul Sharma" → "RS",
    single name → one letter, empty → `?`)
  - `hasEmail` — false for null or blank
  - `copyWith(...)` — replaces only the fields passed

## Used by

Home and profile screens, and the registration wizard. Covered by
`test/models_test.dart`.

## Notes

`phone` is the account identity — the UI must never offer to edit it.
