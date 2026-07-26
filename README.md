# Society Management Platform

A multi-tenant SaaS product that digitises the day-to-day running of residential
housing societies in India — member management, maintenance billing and
collections, accounting, communication, complaints, amenities, staff and
optional gate/visitor management.

Built to work equally well for a **15-flat society with no security guard** and a
**500-flat gated community**, by making every non-core module optional per
society.

> **Requirements:** `Society-Management-Platform-Requirements-v1.0.docx` (v1.0,
> July 2026) is the single source of truth. This README summarises it.

---

## Design principles

| Principle | What it means |
|---|---|
| **Guard-optional** | Small societies have no security staff. No workflow may hard-depend on a guard. With the gate module off, the product must still feel complete. |
| **Modular by feature flag** | Each society enables only the modules it needs. Pricing plans map to flag sets. |
| **Multi-society ready** | A user is linked to societies through *memberships* (user + society + role) — never a single global role. One person can be an owner in one society and a tenant in another. |
| **Low-friction & vernacular** | Elderly committee members and non-technical residents are primary users. English, Hindi and Marathi at launch; large touch targets, minimal jargon. |
| **Audit-grade accounting** | Maharashtra housing societies are statutorily audited. Reports must export in formats a practising auditor accepts. |

---

## Product surfaces

| Surface | Technology | Primary users |
|---|---|---|
| **Resident app** | Flutter (Android + iOS) | Owners, tenants, family members |
| **Admin web dashboard** | Web (responsive) | Secretary, Chairman, Treasurer, committee |
| **Guard app** *(optional)* | Flutter (Android) | Gate staff — big buttons, offline-tolerant |
| **Backend + payments** | Node.js API, PostgreSQL, payment gateway | All surfaces |

---

## Roles

Access control is **membership-based**: permissions come from a
`(user, society, role)` record — never a global user attribute.

- **Super Admin** (platform) — onboards societies, plans, feature flags
- **Society Admin / Secretary** — full control of one society
- **Chairman** — Secretary visibility + approval authority
- **Treasurer** — full billing and accounting access
- **Committee Member** — configurable subset
- **Resident (Owner)** — own unit: bills, complaints, bookings, voting, family,
  vehicles, tenants, documents
- **Resident (Tenant)** — same minus voting, ownership documents, tenant management
- **Guard / Gate Staff** *(only when the gate module is on)*
- **Maintenance Staff** — assigned tasks with photo proof
- **Accountant / Auditor** *(provisioned)* — multi-society accounting access

---

## Modules

**CORE** modules are always on. **FLAG** modules are per-society switches.

| Module | Type | Highlights |
|---|---|---|
| Society & Member Management | CORE | Structure master (towers/floors/units), bulk import, self-registration + approval, ownership transfer, vehicle/pet registry, document vault, tenant lifecycle |
| Billing & Collections | CORE | Configurable charge heads, recurring + ad-hoc invoices, late-fee rules, online payment (UPI/cards/net banking), offline recording, auto-numbered receipts, unit ledger, defaulter aging + reminder campaigns |
| Accounting | CORE | Double-entry books, chart of accounts, automatic postings from billing, expense vouchers with approval, bank reconciliation, Trial Balance / R&P / I&E / Balance Sheet, FY lock, auditor export bundle |
| Communication | CORE | Notices with read receipts, polls & voting, events with RSVP, discussion feed, emergency broadcast, document repository |
| Helpdesk / Complaints | CORE | Categories + photos, Open → Acknowledged → In Progress → Resolved → Closed, staff assignment, SLA escalation, resolution rating |
| Amenity Booking | FLAG | Amenity master, slot picker, approval modes, paid bookings + deposits, admin calendar |
| Staff & Vendors | FLAG | Staff registry, attendance (geo/QR), vendor master, AMC tracking, payment history |
| Gate & Visitors | FLAG | **Guarded mode**: guard app, resident approve/deny, pre-approved QR passes, parcels. **Guardless mode**: resident-generated passes, optional kiosk |
| Meetings & Compliance | FLAG | AGM/SGM scheduler, agenda, quorum, minutes, resolutions, compliance calendar |
| Reports & Dashboards | CORE | Collection efficiency, dues aging, SLA breaches, compliance alerts; PDF/Excel export |
| Auditor Console | PROVISIONED | Data model supports it from day one; UI is Phase 4 |

---

## Current status

This repository currently holds the **resident mobile app (Flutter)** — Phase 1
UI built against placeholder data, with the backend still to come.

**Built:** splash · phone login + OTP · bottom-nav shell · home dashboard ·
billing · notices · complaints · guests/visitors · home services · staff ·
family · vehicles · emergency alerts · profile.

**Quality:** `flutter analyze` clean · 29 tests passing.

> The **admin web dashboard** and **platform-owner console** prototypes live on
> the [`backup`](../../tree/backup) branch.

**Next:** Node.js + PostgreSQL backend, then wiring the app to real data.

---

## Tech stack

- **App:** Flutter 3.44.1 / Dart 3.12.1 · `go_router` · `flutter_bloc` ·
  `google_fonts` (Poppins) · `fl_chart` · `pinput` · `qr_flutter` · `dio` · `intl`
- **Backend (planned):** Node.js + Express · PostgreSQL · JWT auth ·
  payment gateway (UPI / cards / net banking)
- **Design:** Material 3, flat solid colours on a single blue palette

---

## Repository layout

```
society_app/
├── lib/
│   ├── main.dart          app entry + routes
│   ├── core/              shared: constants, theme, utils, widgets
│   └── features/          one folder per feature (models + screens)
├── test/                  unit, widget and smoke tests
├── docs/                  documentation mirror — one .md per source file
├── tools/                 repo scripts (docs mirror checker)
├── .claude/skills/        working skills (design, quality, security, backend, db)
└── CLAUDE.md              project rules
```

### Documentation mirror

`docs/` is a **twin of the source tree** — every file under `lib/` and `test/`
has a Markdown page at the same path, so you can understand the app without
opening the code.

```
lib/main.dart → docs/lib/main.md
```

Verify it stays in sync:

```bash
node tools/check_docs_mirror.mjs
```

---

## Getting started

Requires the Flutter SDK (3.44.1).

```bash
flutter pub get
```

```bash
flutter run
```

Other useful commands:

```bash
flutter analyze          # must print "No issues found!"
flutter test             # 29 tests
flutter build apk --release
flutter build web --release
```

Preview on a phone over the local network:

```bash
flutter run --release -d web-server --web-hostname 0.0.0.0 --web-port 5000
```

Then open `http://<your-pc-ip>:5000` on the phone (use an incognito tab to avoid
a stale cache).

---

## Roadmap

| Phase | Scope | Exit criteria |
|---|---|---|
| **1** | Society & member management · billing & collections with online payment · notices · complaints · resident app + admin dashboard cores | One pilot society running live billing for a full cycle |
| **2** | Full accounting (vouchers, books, reconciliation, reports, FY close) · amenities · polls/events/feed · document repository | A quarter of books maintained in-app and accepted by a practising auditor |
| **3** | Gate module (guarded + guardless, guard app) · staff & vendors · meetings & compliance | One guarded and one guardless society live; an AGM run in-app |
| **4** | Auditor multi-society console · auditor-initiated onboarding | One auditor managing 5+ societies |

---

## Non-functional requirements

- **Multi-tenancy** — single database, `society_id` scoping on every tenant
  table, isolation enforced at the API layer, no cross-society leakage
- **Performance** — app cold start < 3s on mid-range Android · API p95 < 500ms ·
  invoice run for 500 units < 2 minutes
- **Availability** — 99.5% monthly uptime; offline payment recording still works
  if the gateway is down
- **Offline tolerance** — guard app queues entries locally; resident app caches
  last-known bills, notices and passes
- **Security** — OTP auth with JWT, server-side role checks, encryption in
  transit and at rest, payment data never stored (gateway tokenisation), OTP rate
  limiting
- **Privacy** — DPDP Act alignment: consent at registration, data-deletion
  workflow, visitor photos auto-purged after a retention period
- **Auditability** — immutable audit log for financial and role changes;
  financial-year lock prevents back-dated tampering

---

## Open decisions

- Product name and branding
- Pricing model (per-flat per-month vs flat monthly per society) and
  plan-to-flag mapping
- Whether the staff app is a separate binary or a mode inside the resident app
- Tally export format priority for accountant adoption

---

## Contributing

Read [`CLAUDE.md`](CLAUDE.md) first — it holds the project rules. In short:

1. Follow the design system (`AppColors` palette, flat colours, shared widgets)
2. `flutter analyze` must be clean and all tests must pass
3. Update the matching page in `docs/` for every code change
