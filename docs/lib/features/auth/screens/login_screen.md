# login_screen.dart

Mirrors `lib/features/auth/screens/login_screen.dart`.

**Purpose** — phone-number entry for existing residents; sends an OTP. Also the
entry point to registration for new ones.

## What's inside

- `LoginScreen` (StatefulWidget)
  - phone `TextEditingController` (disposed in `dispose()`)
  - `_isLoading` while the OTP request runs
  - `_sendOtp()` — validates, shows loading, then routes to the OTP screen with
    the phone number as `extra`
- `_LoginHeader` — brand mark and "Welcome Back 👋"
- A **"Create an account"** outlined button routing to `/register`, under a
  "New here?" divider
- An `InfoBanner` explaining that registrations need admin approval

## Route

`AppRoutes.login` → `/login`.

## Notes

The OTP call is simulated; the backend version must be rate-limited and must not
reveal whether an account exists.
