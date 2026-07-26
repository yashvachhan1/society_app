# app_card.dart

Mirrors `lib/core/widgets/app_card.dart`.

**Purpose** — the standard white card used across the app; optionally tappable.

## What's inside

- `AppCard` (StatelessWidget)
  - `child` — the card's content
  - `padding` — inner padding (defaults to a standard inset)
  - `onTap` — optional; when set the card gets an ink ripple
  - `borderRadius` — corner radius (default matches the theme)

Renders a `Material` + `InkWell` with the surface colour and a soft
`AppColors.cardShadow`.

## Used by

Most feature screens for list rows and content blocks.

## Notes

Prefer this over hand-rolling a `Container` so every card looks identical.
Covered by `test/widgets_test.dart`.
