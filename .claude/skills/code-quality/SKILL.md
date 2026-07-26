---
name: code-quality
description: The SonarQube A-grade quality gate for this repo — zero duplication, low complexity, clean analyze, naming, and the analyze/test commands that must pass before work is done. Load before finishing a feature, before handing work back to the user, and whenever you are about to copy-paste code.
---

# Code quality gate

The user requires an **A grade in SonarQube**. That means four things: no
duplicated code, low complexity, a clean analyzer, and real test coverage.

## 1. Zero duplication — the rule that bites most

If the same UI or logic appears in **two features**, it moves into `lib/core/`.
Do not copy a widget between feature folders.

Before writing a widget or helper:
1. Search `lib/core/widgets/` and `lib/core/utils/` for something that already
   does it (`AppCard`, `SectionHeader`, `StatusChip`, `IconChip`, `InfoBanner`,
   `EmptyState`, `formatRupees`).
2. If a feature-local version exists and a second feature now needs it — **move
   it to core first**, then use it from both.
3. Make shared widgets take primitives (`String`, `IconData`, `Color`), not a
   feature's model class, so any feature can pass its own data.

## 2. Complexity

- One widget/class = one job. Split a `build` that grows past ~60 lines into
  small private widgets (`_Header`, `_Row`, `_Footer`).
- Functions stay short; prefer early returns over nested `if`.
- Avoid deep conditional chains — use `switch` expressions
  (`switch (status) { 'Active' => ..., _ => ... }`) like the existing
  status/priority helpers.
- Put derived logic on the model (`isPresent`, `statusIcon`), not in `build`.
- No magic numbers for layout decisions — name the constant.

## 3. Clean analyzer — non-negotiable

```bash
C:/flutter/bin/flutter.bat analyze
```

Must print **"No issues found!"**. Warnings and infos are not acceptable,
including "unused parameter" and import-ordering infos.

Dart specifics the analyzer enforces here: `const` wherever possible,
alphabetical import sections (`core/` before `features/`), null-aware elements
(`?action` rather than `if (x != null) x!`), and `withValues(alpha:)` instead of
the deprecated `withOpacity`.

## 4. Tests

Current baseline: **29 tests passing** — unit tests for models/formatters, smoke
tests that render every feature screen, and a boot test.

```bash
C:/flutter/bin/flutter.bat test
```

- Add a smoke test to `test/screens_smoke_test.dart` for every new screen.
- Test what the user can do (render, tap, assert the visible result), not
  implementation details.
- When a label changes, update the assertion — don't weaken it to `findsAny`
  unless the duplicate is genuinely expected (then say why in a comment).

## 5. Node backend (when it exists)

Same bar: `eslint` clean, `prettier` formatted, `jest` tests for every route
(happy path + auth failure + **cross-tenant denial**), no `console.log` in
committed code, no dead code or commented-out blocks.

## Definition of done

- [ ] `flutter analyze` → No issues found!
- [ ] `flutter test` → all passing
- [ ] No copy-pasted block that now exists twice (extract to `lib/core/`)
- [ ] No unused imports, fields, parameters or dead files left behind
- [ ] New behaviour has a test
- [ ] **Do not commit or push** — report what changed and give the user the
      command to run
