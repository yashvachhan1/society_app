# Documentation mirror

`docs/` is a **twin of the source tree**. Every code file has one Markdown file
at the same path, so you can read what the app does without opening the code.

```
lib/main.dart                              → docs/lib/main.md
lib/core/theme/app_theme.dart              → docs/lib/core/theme/app_theme.md
lib/features/home/screens/home_screen.dart → docs/lib/features/home/screens/home_screen.md
```

## The rule

The mirror must always match the code:

- **New code file** → create its `.md` in the same relative path
- **Code changed** → update that file's `.md` in the same commit
- **Code file deleted or moved** → delete or move its `.md` too

This is enforced by the `docs-mirror` skill in `.claude/skills/`.

## What each page contains

| Section | Meaning |
|---|---|
| **Purpose** | what the file is for, in one line |
| **What's inside** | the classes, widgets, fields and helpers it declares |
| **Used by / Uses** | how it connects to the rest of the app |
| **Notes** | rules, gotchas and decisions worth remembering |

## Map of the app

- `lib/main.md` — entry point and all routes
- `lib/core/` — shared theme, colours, constants, formatters, widgets
- `lib/features/<name>/` — one folder per feature (models + screens)
- `test/` — unit, widget and smoke tests

Related: `CLAUDE.md` (project rules) and `.claude/skills/` (working skills).
