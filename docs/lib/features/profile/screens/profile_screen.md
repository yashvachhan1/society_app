# profile_screen.dart

Mirrors `lib/features/profile/screens/profile_screen.dart`.

**Purpose** — the resident's account, field by field.

## What's inside

- `ProfileScreen` (StatefulWidget) — holds the selected `AppLanguage`
- `_ProfileHeader` — blue header with `PhotoAvatar` (`users.photo_url`, falling
  back to initials), a verified tick when the membership is active, the name,
  and `_HeaderChip` rows for the flat and role
- `_AccountCard` — the **`users`** row: full name, mobile (login ID), email,
  profile photo, language, account status, last login
- `_MembershipCard` — the **`memberships`** row: society, flat, role, status,
  member since, and "Valid till" when `end_date` is set
- `_LanguageCard` — `users.language`
- `_LogoutButton`
- `_EditProfileSheet` — edits `photo_url`, `name` and `email`; the phone number
  is locked because it is the account identifier

## Route

`AppRoutes.profile` → `/profile` (Account tab).

## Notes

Only columns the resident owns are editable. Society details, unit structure and
membership status are set by the admin and shown read-only.
