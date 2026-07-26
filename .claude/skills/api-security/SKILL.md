---
name: api-security
description: Security rules for the Node.js + PostgreSQL backend and anything that touches auth, tenant data, money or secrets — tenant isolation, role checks, SQL injection, password/OTP handling, JWT, rate limiting, payment webhooks, secrets and logging. Load before writing or reviewing any API route, query, auth flow or payment integration.
---

# API security

This is a multi-tenant SaaS holding residents' personal data and money. A leak
across properties is the worst failure this system can have. Treat every rule
here as mandatory, not advisory.

## 1. Tenant isolation — the #1 rule

Every tenant-owned table carries `property_id`. Every read and every write must
be scoped to the property from the **authenticated token**, never from the
request body or a query parameter a client can change.

```js
// WRONG — client picks the property, so it can read any society's data
const { propertyId } = req.query;
const bills = await db.query('SELECT * FROM bills WHERE property_id = $1', [propertyId]);

// RIGHT — scope comes from the verified token
const bills = await db.query(
  'SELECT * FROM bills WHERE property_id = $1 AND id = $2',
  [req.auth.propertyId, req.params.id],
);
```

- A lookup by id must **still** include `property_id` in the `WHERE`, otherwise
  guessing an id leaks another property's row.
- The platform owner is the only role that may query across properties, and only
  through routes explicitly marked as owner-scoped.
- Put tenant scoping in the repository layer so no route can forget it, and add
  a test that proves property A cannot fetch property B's record (expect 404).

## 2. Authentication and roles

Roles: `owner` (platform), `admin` (one property), `resident`.

- Verify a JWT on every non-public route; put `userId`, `role`, `propertyId`
  into `req.auth`. Short-lived access token (~15 min) + refresh token.
- Authorize per route with an explicit middleware — `requireRole('admin')`. Deny
  by default: a route with no role rule must not be reachable.
- Never trust `role` or `propertyId` sent by the client.
- Passwords: `bcrypt` (cost ≥ 12) or `argon2`. Never store or log plain text.
- OTP: 6 digits, hashed at rest, single use, ~5 min expiry, max 5 attempts.
- Do not reveal whether a phone/email exists ("if the account exists, an OTP was
  sent"). Keep login and OTP failures generic.

## 3. Modular services are a security boundary

A property only has the services it enabled. The backend must **reject** calls
to a disabled module (403) — hiding the button in the UI is not enough. Check
the property's enabled-module list in middleware, not in each handler.

## 4. SQL injection

- Always parameterized queries (`$1, $2`) or the query builder's binding.
- **Never** build SQL by string concatenation or template literals with user
  input — not even for `ORDER BY`. Whitelist sortable columns instead.
- Table/column names can never come from user input.

## 5. Input validation

Validate every request body, param and query with a schema (zod) at the route
edge; reject unknown fields. Validate types, lengths, ranges and formats
(phone, email, amount > 0). Never pass a raw body into an ORM/update statement —
mass assignment lets a client set `role` or `property_id`.

## 6. Rate limiting and abuse

Rate-limit by IP **and** by account: login, OTP send/verify, password reset,
payment creation, file upload. OTP send needs a cooldown so it cannot be used to
spam a phone number. Return 429 with a retry hint.

## 7. Payments (Razorpay)

- Create orders **server-side only**; the client never sends the amount to
  charge — it sends what it is paying for, the server computes the amount.
- **Always verify the webhook/callback signature** (HMAC with the secret) before
  marking anything paid; ignore unsigned or mismatched callbacks.
- Make payment handling idempotent (unique constraint on the gateway payment id)
  so a retried webhook cannot double-credit.
- Keep the key secret server-side; only the public key id reaches the client.

## 8. Secrets and config

- Everything sensitive comes from environment variables. `.env` is git-ignored;
  commit only `.env.example` with empty values.
- No secret, token or key in the repo, in the Flutter apps, or in logs.
- Rotate anything that has ever been committed — treat it as public.

## 9. Transport, headers, uploads

- HTTPS only; `helmet` for security headers; CORS allow-list of our own app
  origins (never `*` with credentials).
- Uploads: check MIME + extension + size cap, store outside the web root or in
  object storage with generated names, never serve user files from the API host
  by original filename.

## 10. Logging and errors

- Log auth events, role denials and payment state changes with `userId` +
  `propertyId`.
- **Never log** passwords, OTPs, tokens, card data or full request bodies of
  auth routes.
- Return generic messages to clients (`"Something went wrong"`); keep stack
  traces server-side. No SQL text or file paths in an API response.

## Checklist before any backend PR

- [ ] Every query filters by `property_id` from `req.auth`
- [ ] Route has an explicit role requirement
- [ ] Disabled-module access returns 403
- [ ] All SQL parameterized; no string-built queries
- [ ] Request schema validated; unknown fields rejected
- [ ] Rate limit on auth/OTP/payment routes
- [ ] Payment signature verified and idempotent
- [ ] No secrets or personal data in code or logs
- [ ] A test proves cross-property access fails
