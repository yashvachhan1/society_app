# widget_test.dart

Mirrors `test/widget_test.dart`.

**Purpose** — the boot test: the app starts, shows the splash, then reaches the
language picker.

## What it asserts

- Splash shows **Society App** and **Smart Society Management**
- After the splash timer, **Choose your language** is on screen

## Notes

This is the one test that exercises `main.dart` and the router together — if it
fails, routing or theming is broken.
