# membership.dart

Mirrors `lib/core/models/membership.dart`.

**Purpose** — the link between a user, a society and a role. Mirrors the
**`memberships`** table, which is the heart of access control.

## What's inside

- `MembershipRole` (enum) — `admin`, `chairman`, `treasurer`, `committee`,
  `owner`, `tenant`, `guard`, `staff`, `accountant`; each with a display `label`.
- `MembershipStatus` (enum) — `pending`, `active`, `rejected`, `ended`; each with
  a display `label`. A self-registered resident starts as **pending**.
- `Membership` — `societyId`, `role`, `unitId` (nullable; set for owner/tenant),
  `status`, `startDate`, `endDate`.
  - `isActive` / `isPending`
  - `isResident` — true for owner and tenant roles

## Used by

Home and profile screens. Covered by `test/models_test.dart`.

## Notes

Permissions must always resolve from a membership — never from a global flag on
the user. One person can be an owner in one society and a tenant in another.
