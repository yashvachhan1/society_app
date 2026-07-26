# otp_screen.dart

Mirrors `lib/features/auth/screens/otp_screen.dart`.

**Purpose** — enter the 6-digit OTP and sign in.

## What's inside

- `OtpScreen` (StatefulWidget) — takes the `phone` it is verifying.
  - a resend countdown (`_resendSeconds`, `_canResend`) started in `initState`
  - `_startTimer()` — ticks the countdown, then enables resend
  - `_verifyOtp()` — shows the loading state, then enters the app shell
  - uses `pinput` for the code boxes

## Route

`AppRoutes.otp` → `/otp`.

## Notes

Timer and controllers are cleaned up in `dispose()`. When the backend arrives,
OTPs must be single-use, short-lived and rate-limited (see the `api-security`
skill).
