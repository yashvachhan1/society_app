# profile_screen.dart

Mirrors `lib/features/profile/screens/profile_screen.dart`.

**Purpose** — the resident's account, field by field.

## What's inside

- `ProfileScreen` (StatefulWidget) — holds the selected `AppLanguage` and the
  photo bytes chosen from the camera or gallery
  - `_changeLanguage()` — opens `_LanguageSheet`
- `_ProfileHeader` — blue header with a `PhotoAvatar` (display only), a verified
  tick when the membership is active, the name, and `_HeaderChip` rows for the
  flat and role
- `_AccountCard` — the **`users`** row: full name, mobile (login ID), email,
  **language** (tappable → language sheet), account status, last login
- `_MembershipCard` — the **`memberships`** row: society, flat, role, status,
  member since, and "Valid till" when `end_date` is set
- `_LanguageSheet` — the language picker
- `_LogoutButton`
- `_EditProfileSheet` — the one place the resident edits their own record:
  **profile photo** (camera / gallery / remove, via `pickProfilePhoto`),
  `users.name` and `users.email`. The phone number is locked because it is the
  account identifier. Picking a photo calls `onPhotoChanged` so the header
  behind the sheet updates immediately.

## Route

`AppRoutes.profile` → `/profile` (Account tab).

## Notes

Editing lives in one place — the Edit profile sheet (pencil icon in the app
bar). The header avatar and the Account rows only display; language is the one
exception, changed in place from its row.
