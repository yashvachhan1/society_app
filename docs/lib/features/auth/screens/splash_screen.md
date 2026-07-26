# splash_screen.dart

Mirrors `lib/features/auth/screens/splash_screen.dart`.

**Purpose** — the branded first screen; animates the logo, then moves on.

## What's inside

- `SplashScreen` (StatefulWidget) with an `AnimationController`
  (fade + scale, `Curves.easeOutCubic`).
- Shows `SkylineLogo`, the title **Society App** and the tagline
  **Smart Society Management** on the brand blue background.
- After the animation it navigates to the login screen.

## Route

`AppRoutes.splash` → `/` — the app's initial location.

## Notes

Controller is disposed in `dispose()`. Covered by `test/widget_test.dart`
(splash → login).
