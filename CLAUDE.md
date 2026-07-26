# Society Management App — project rules

Flutter mobile app for society residents (owners & tenants). Single Flutter
project, one repo. The backend will be Node.js + PostgreSQL.

> The admin panel and platform-owner console were removed from this branch to
> focus on the resident app. That work is preserved on the **`backup`** branch.

## Layout

```
society_app/
├── lib/
│   ├── main.dart              app entry + go_router routes
│   ├── core/                  SHARED across features
│   │   ├── constants/         AppRoutes, AppConstants
│   │   ├── theme/             AppColors, AppTheme
│   │   ├── utils/             formatters (formatRupees)
│   │   └── widgets/           AppCard, StatusChip, EmptyState, InfoBanner,
│   │                          IconChip, SectionHeader, SkylineLogo
│   └── features/<feature>/    one folder per feature
│       ├── models/            typed models (never Map<String, dynamic>)
│       ├── screens/
│       └── widgets/
├── test/                      unit + widget + smoke tests
├── android/ ios/ web/ …       platform folders
└── (backend to come)          Node.js + PostgreSQL API
```

Features today: `auth`, `home`, `shell`, `billing`, `notices`, `complaints`,
`guests`, `services`, `staff`, `family`, `vehicles`, `alerts`, `profile`.

Anything used by two or more features belongs in `lib/core/` — that is what
keeps the SonarQube duplication score at zero.

## Source of truth

`Society-Management-Platform-Requirements-v1.0.docx` (v1.0, July 2026) is the
authoritative requirements document — every screen should trace back to a
requirement in it. `README.md` summarises it. Read the docx before planning any
new module.

## Product rules that shape the app

1. **Guard-optional** — many small societies have no security staff. No workflow
   may hard-depend on a guard; with the gate module off the product must still
   feel complete, and no gate UI may appear anywhere.
2. **Modular by feature flag** — a society enables only the modules it needs
   (CORE modules are always on; the rest are per-society flags). A disabled
   module must not appear in navigation and must be rejected by the backend.
3. **Membership-based roles** — permissions come from a `(user, society, role)`
   record, never a global user attribute. One person can be an owner in one
   society and a tenant in another; the app needs a society switcher.
4. **Vernacular** — English, Hindi and Marathi at launch. Allow ~30% text
   expansion, avoid text in images, keep touch targets large.
5. **Audit-grade** — accounting is the system of record for a statutory audit;
   financial-year lock and an immutable audit log are requirements, not extras.

Delivery is phased: **1** members + billing + notices + complaints ·
**2** accounting + amenities + community · **3** gate + staff + meetings ·
**4** auditor console. This app is Phase 1.

## Commands

Flutter lives at `C:\flutter` (3.44.1, Dart 3.12.1). Run from the repo root:

```bash
C:/flutter/bin/flutter.bat analyze
C:/flutter/bin/flutter.bat test
C:/flutter/bin/flutter.bat build web --release
C:/flutter/bin/flutter.bat build apk --release
```

`analyze` must print **No issues found!** and all tests must pass before work is
considered done.

## Documentation mirror — always keep it in sync

`docs/` is a twin of the source tree: every file under `lib/` and `test/` has a
Markdown page at the same path (`lib/main.dart` → `docs/lib/main.md`).

- Create a `.md` whenever you create a code file
- Update the `.md` whenever you change that code file
- Delete/move the `.md` when the code file goes

Verify with `node tools/check_docs_mirror.mjs` (must print OK). Details in the
`docs-mirror` skill.

## Working agreements

- **Never run `git commit` or `git push`.** The user does all git writes. Make
  the file changes, then tell them what to run.
- **Never edit source files with PowerShell `Get-Content`/`Set-Content`** — it
  corrupts `₹ • —`. Use the Edit/Write tools.
- Quality over speed: build one screen at a time, verify it, show the user,
  then move on.
- Explain in simple Hinglish; the user is non-technical.
- Deploy: Vercel builds from the repo root via `vercel-build.sh` → `build/web`.

## Skills

Load the matching skill before working in that area: `design-system`,
`flutter-screen`, `code-quality`, `docs-mirror`, `api-security`, `backend-api`,
`db-schema`.
