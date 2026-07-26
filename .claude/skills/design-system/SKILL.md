---
name: design-system
description: The visual rules for every screen in this app — colour palette, typography, spacing, cards, and the shared widget catalogue in lib/core/widgets. Load this before writing or restyling ANY Flutter UI, before picking a colour, and before creating a widget that might already exist in core.
---

# Design system

One design language across the app. It lives in `lib/core/` — never re-invent it
inside a feature.

## Colours — `AppColors` only

From `lib/core/theme/app_theme.dart`. **Never write a raw `Color(0x...)` in a
feature.** If a colour seems missing, reuse the closest one.

| Token | Hex | Use |
|---|---|---|
| `primary` | `#1565C0` | brand blue, headers, selected states, primary buttons |
| `primaryLight` | `#1E88E5` | muted accents |
| `primaryDark` | `#0D47A1` | rare emphasis |
| `accent` | `#00ACC1` | secondary category tint |
| `success` | `#43A047` | paid, present, resolved |
| `warning` | `#FB8C00` | pending, due, in progress |
| `error` | `#E53935` | overdue, absent, urgent, destructive |
| `background` | `#F5F7FA` | page background, inset fields |
| `surface` | `#FFFFFF` | cards |
| `textPrimary` | `#1A1A2E` | headings and values |
| `textSecondary` | `#6B7280` | labels, captions, meta |
| `divider` | `#E5E7EB` | borders, separators |
| `cardShadow` | `#1A000000` | card shadow only |

**Hard rules the user has repeatedly asked for:**
- **FLAT solid colours — no gradients anywhere.** Gradient banding was rejected.
- **Stay inside the blue family.** Off-theme colours (a teal/green card) were
  rejected. Status colours (green/amber/red) are allowed only as *status*
  meaning, and only as a 10–14% alpha tint behind an icon or inside a pill.
- Tinted surfaces use `color.withValues(alpha: 0.12)` — that is the house tint.
- **Material icons only.** Iconsax was tried and rejected ("pehle wale" —
  the user prefers the Material set).

## Typography

Poppins via `google_fonts`, wired into `AppTheme.lightTheme`. Sizes in use —
match them, don't invent:

- Screen title 18–22 w700 · section heading 16–18 w600/w700
- Card value 20–26 w700 · body 14 w500/w600 · label 13
- Caption/meta 11.5–12.5 in `textSecondary`

## Shape and spacing

- Radius: cards 14–16, buttons/fields 12, pills 20
- Card padding 16–20 · screen padding 16–20
- Gaps: 20–24 between sections, 12–16 inside a grid, 8 between chips
- Cards: `surface` fill, subtle `divider` border and/or soft `cardShadow` —
  never heavy elevation, never two same-coloured blocks touching (they blend
  into a blob)
- Accent style that works well here: a **left colour bar** on list cards
  (see the notice card) instead of a coloured background

## Always reuse — `lib/core/widgets/`

Check before building anything: `AppCard`, `SectionHeader`, `StatusChip`,
`IconChip`, `InfoBanner`, `EmptyState`, `SkylineLogo` (brand mark).
One import: `package:society_app/core/widgets/widgets.dart`.

If the same UI appears in two features, move it into `lib/core/widgets/` — that
is also what keeps the SonarQube duplication score at zero (`code-quality`).

## Layout habits

- Full-width segmented filter bars (`Row` of `Expanded` tabs) — selected tab is
  filled `primary` with white text.
- Module grids: fixed rows with `spaceBetween`, ~64px icon tiles.
- Every `Text` showing data needs `maxLines` + `TextOverflow.ellipsis` so
  nothing wraps mid-word.
- Money is formatted with `formatRupees` (Indian grouping, `₹ 1,25,000`).

## States

Every screen needs real states, not blank flashes: loading (shimmer/skeleton),
empty (`EmptyState` with an icon + one line), error (message + retry).

## Before you call a screen done

1. `C:/flutter/bin/flutter.bat analyze` → **No issues found!**
2. Check it at phone width — no overflow, no mid-word wrap.
3. Compare against a neighbouring screen: same paddings, same card style, same
   type scale. If it looks "new", it is wrong.
