---
name: docs-mirror
description: Keeps docs/ a perfect twin of the source tree — every code file has a matching Markdown page at the same path. Load this whenever you create, change, rename or delete a file under lib/ or test/, and before finishing any task that touched code, so the docs never drift from the code.
---

# Docs mirror

`docs/` mirrors the source tree one-to-one. A reader must be able to understand
the app from `docs/` alone, without opening a single `.dart` file.

```
lib/main.dart                              → docs/lib/main.md
lib/core/theme/app_theme.dart              → docs/lib/core/theme/app_theme.md
lib/features/home/screens/home_screen.dart → docs/lib/features/home/screens/home_screen.md
test/models_test.dart                      → docs/test/models_test.md
```

Only `lib/` and `test/` are mirrored. Platform folders (`android/`, `ios/`,
`web/`, …) and generated output are not.

## The three rules — never skip these

1. **New code file** → create its `.md` at the same relative path, in the **same
   change**. A new `.dart` without its `.md` is an unfinished task.
2. **Code changed** → update that file's `.md` in the **same change**. If you
   added a widget, a field, a getter, a route or changed behaviour, the page must
   say so. Docs that describe code that no longer exists are worse than no docs.
3. **File deleted or moved** → delete or move its `.md` the same way.

This applies to every edit, however small — a renamed field is a doc change too.

## Page template

Keep pages short and factual. Use this shape:

```markdown
# <file name>

Mirrors `<path/to/file.dart>`.

**Purpose** — one line: what this file is for.

## What's inside
- `ClassName` — what it is, and its fields/parameters
- `helperName()` — what it does
- Private widgets worth knowing (`_Header`, `_FilterBar`)

## Route            ← screens only
`AppRoutes.x` → `/path` (where it sits in the navigation)

## Used by / Uses
Who imports this, and what this depends on.

## Notes
Rules, gotchas, product decisions worth remembering.
```

Screens also mention their route; models list their fields and derived getters;
tests list what they cover.

## Writing style

- Plain English, short sentences — the product owner reads these too.
- State facts you have verified in the file. **Never guess** a field name, a
  route or a behaviour — open the file and check.
- Record *why* when a decision was deliberate ("the full-width filter was an
  explicit request — keep it"). That context is the real value.
- Do not paste large code blocks; describe instead. Names in `backticks`.

## Verify

Run the checker before you call any code task done:

```bash
node tools/check_docs_mirror.mjs
```

It prints `OK — N source files, N docs, mirror is complete.` or lists exactly
which docs are missing or orphaned. Treat a failure like a failing test.

## Definition of done for any code change

- [ ] Every new `.dart` has its `.md`
- [ ] Every touched `.dart` has an updated `.md`
- [ ] Deleted/renamed files handled on both sides
- [ ] `node tools/check_docs_mirror.mjs` → OK
- [ ] `docs/README.md` still describes the layout correctly
