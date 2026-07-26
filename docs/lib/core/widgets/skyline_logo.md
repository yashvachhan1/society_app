# skyline_logo.dart

Mirrors `lib/core/widgets/skyline_logo.dart`.

**Purpose** — the app's brand mark: a three-building skyline with lit windows in
a white rounded badge.

## What's inside

- `SkylineLogo` (StatelessWidget) — `size` (default 104), `radius` (default 28).
- `_SkylinePainter` (private `CustomPainter`) — draws three rounded towers in
  `#1E88E5`, `#1565C0`, `#42A5F5` plus 20 white windows, all scaled from a 48×48
  design space so it stays crisp at any size.

## Used by

`splash_screen.dart` and `login_screen.dart`.

## Notes

Drawn in code — no image asset, so it never pixelates and adds no bundle weight.
