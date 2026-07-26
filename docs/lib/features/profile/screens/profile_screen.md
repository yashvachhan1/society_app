# profile_screen.dart

Mirrors `lib/features/profile/screens/profile_screen.dart`.

**Purpose** — the resident's account, field by field.

## What's inside

- `ProfileScreen` (StatefulWidget) — holds the selected `AppLanguage`
- `_ProfileHeader` — blue header: avatar with initials, a verified tick when the
  membership is active, the name, and `_HeaderChip` rows for the flat and role
- `_AccountCard` — the **`users`** row: full name, mobile (login ID), email
  (or "Not added"), language, account status, last login
- `_MembershipCard` — the **`memberships`** row plus what it points at: society,
  flat, role, status, member since
- `_LanguageCard` — `users.language`, the one setting stored today
- `_LogoutButton`
- `_EditProfileSheet` — edits `users.name` and `users.email`; the phone number is
  locked because it is the account identifier

## Route

`AppRoutes.profile` → `/profile` (second bottom-nav tab, labelled "Account").

## Notes

The old placeholder menu (documents, notifications, privacy, help, settings) was
removed — those screens do not exist yet, and the schema has nothing behind them.
