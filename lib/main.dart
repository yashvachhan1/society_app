import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/alerts/screens/alerts_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/billing/screens/billing_screen.dart';
import 'features/complaints/screens/complaints_screen.dart';
import 'features/family/screens/family_screen.dart';
import 'features/guests/screens/guests_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/notices/screens/notices_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/staff/screens/staff_screen.dart';
import 'features/vehicles/screens/vehicles_screen.dart';

final _router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
    GoRoute(
      path: AppRoutes.otp,
      builder: (_, state) => OtpScreen(phone: state.extra as String? ?? ''),
    ),
    GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
    GoRoute(path: AppRoutes.billing, builder: (_, _) => const BillingScreen()),
    GoRoute(path: AppRoutes.notices, builder: (_, _) => const NoticesScreen()),
    GoRoute(path: AppRoutes.complaints, builder: (_, _) => const ComplaintsScreen()),
    GoRoute(path: AppRoutes.guests, builder: (_, _) => const GuestsScreen()),
    GoRoute(path: AppRoutes.staff, builder: (_, _) => const StaffScreen()),
    GoRoute(path: AppRoutes.alerts, builder: (_, _) => const AlertsScreen()),
    GoRoute(path: AppRoutes.family, builder: (_, _) => const FamilyScreen()),
    GoRoute(path: AppRoutes.vehicles, builder: (_, _) => const VehiclesScreen()),
    GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
  ],
);

void main() {
  runApp(const SocietyApp());
}

class SocietyApp extends StatelessWidget {
  const SocietyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
