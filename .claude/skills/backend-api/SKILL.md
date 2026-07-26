---
name: backend-api
description: How to build the Node.js backend for this platform — project layout, the route/controller/service/repository split, request validation, response and error format, auth middleware, config and tests. Load before creating or changing any API endpoint, middleware or service.
---

# Backend API conventions

Node.js (LTS) + Express + PostgreSQL (`pg`), plain JavaScript or TypeScript —
whichever the repo already uses. The API serves all three Flutter apps.

Read the `api-security` skill together with this one; every rule there applies.

## Layout

```
apps/backend/
├── src/
│   ├── app.js              express app: helmet, cors, json, routes, error handler
│   ├── server.js           starts the http server
│   ├── config/             env loading + validation (fails fast if a var is missing)
│   ├── middleware/         auth, requireRole, requireModule, rateLimit, errorHandler
│   ├── modules/
│   │   └── <feature>/      one folder per feature (properties, billing, complaints…)
│   │       ├── <f>.routes.js       paths + middleware only
│   │       ├── <f>.controller.js   http in/out, no business logic
│   │       ├── <f>.service.js      business rules
│   │       ├── <f>.repository.js   SQL — the ONLY place queries live
│   │       └── <f>.schema.js       zod request schemas
│   └── db/
│       ├── pool.js         pg Pool
│       └── migrations/     see the db-schema skill
└── tests/
```

**The layer rule:** routes → controller → service → repository. A controller
never writes SQL; a repository never touches `req`/`res`. This keeps functions
small (see `code-quality`) and makes tenant scoping easy to enforce in one place.

## A route, end to end

```js
// billing.routes.js
router.get(
  '/bills/:id',
  auth,                       // verifies JWT -> req.auth {userId, role, propertyId}
  requireRole('admin', 'resident'),
  requireModule('billing'),   // property must have this service enabled
  validate({ params: billIdSchema }),
  billingController.getBill,
);

// billing.controller.js
export async function getBill(req, res, next) {
  try {
    const bill = await billingService.getBill(req.auth, req.params.id);
    res.json({ data: bill });
  } catch (err) {
    next(err);
  }
}

// billing.repository.js — property_id ALWAYS in the WHERE
export function findBillById(propertyId, id) {
  return db.query(
    'SELECT * FROM bills WHERE property_id = $1 AND id = $2',
    [propertyId, id],
  ).then((r) => r.rows[0] ?? null);
}
```

## Responses

Consistent envelope so the Flutter `dio` client can parse one shape:

```json
{ "data": { } }                                  // success
{ "data": [ ], "meta": { "page": 1, "total": 87 } }  // list
{ "error": { "code": "NOT_FOUND", "message": "Bill not found" } }
```

Status codes: 200 ok · 201 created · 400 validation · 401 not logged in ·
403 wrong role or disabled module · 404 missing (also used for another
property's row) · 409 conflict · 429 rate limited · 500 unexpected.

## Errors

Throw typed app errors (`NotFoundError`, `ForbiddenError`, `ValidationError`)
from services; one `errorHandler` middleware converts them to the envelope,
logs the detail server-side and returns a generic message for 500s. No
`try/catch` that swallows an error silently.

## Lists

Paginate every list (`?page=&limit=`, cap `limit` at 100), sort only on a
whitelisted column, and return `meta.total`. Filters are explicit query params
validated by the schema.

## Async and transactions

`async/await` only. Wrap multi-statement writes in a transaction
(`BEGIN/COMMIT/ROLLBACK`) via a helper so a partial write cannot happen — for
example creating a property plus its admin plus its enabled modules.

## Config

All settings via env with validation at boot (`DATABASE_URL`, `JWT_SECRET`,
`RAZORPAY_*`, `PORT`). Never a hardcoded URL, key or connection string. Ship
`.env.example`; keep `.env` git-ignored.

## Tests

For every route: happy path, validation failure, unauthenticated, wrong role,
and **cross-property access returns 404**. Run against a test database with the
same migrations; reset state between tests.

## Definition of done

- [ ] Layers respected (no SQL in controllers)
- [ ] Tenant scoping in the repository; role + module middleware on the route
- [ ] zod schema for body/params/query
- [ ] Consistent response envelope and status codes
- [ ] Pagination on lists
- [ ] Tests incl. cross-tenant denial · `eslint` clean
