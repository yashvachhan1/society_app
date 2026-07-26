import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:society_app/core/constants/app_constants.dart';
import 'package:society_app/core/theme/app_theme.dart';
import 'features/auth/screens/language_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/common/screens/empty_module_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/registration/screens/pending_approval_screen.dart';
import 'features/registration/screens/registration_screen.dart';
import 'features/shell/main_shell.dart';

/// App routes.
///
/// Onboarding is a straight line — splash → language → login (or register) →
/// OTP → the signed-in shell. New residents branch off to registration, which
/// ends at the pending-approval screen until an admin approves them.
///
/// Inside the shell the Account tab has real data; every other module keeps its
/// tile on the home grid but opens [EmptyModuleScreen] until it is built.
final _router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
    GoRoute(path: AppRoutes.language, builder: (_, _) => const LanguageScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
    GoRoute(
      path: AppRoutes.register,
      builder: (_, _) => const RegistrationScreen(),
    ),
    GoRoute(
      path: AppRoutes.pendingApproval,
      builder: (_, _) => const PendingApprovalScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (_, state) => OtpScreen(phone: state.extra as String? ?? ''),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, _) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'services',
                  builder: (_, _) => const EmptyModuleScreen(
                    title: 'Home Services',
                    icon: Icons.handyman,
                  ),
                ),
                GoRoute(
                  path: 'complaints',
                  builder: (_, _) => const EmptyModuleScreen(
                    title: 'Complaints',
                    icon: Icons.build_circle,
                  ),
                ),
                GoRoute(
                  path: 'guests',
                  builder: (_, _) => const EmptyModuleScreen(
                    title: 'Guests',
                    icon: Icons.qr_code_scanner,
                  ),
                ),
                GoRoute(
                  path: 'staff',
                  builder: (_, _) => const EmptyModuleScreen(
                    title: 'Staff',
                    icon: Icons.people,
                  ),
                ),
                GoRoute(
                  path: 'family',
                  builder: (_, _) => const EmptyModuleScreen(
                    title: 'Family',
                    icon: Icons.family_restroom,
                  ),
                ),
                GoRoute(
                  path: 'vehicles',
                  builder: (_, _) => const EmptyModuleScreen(
                    title: 'Vehicles',
                    icon: Icons.directions_car,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.billing,
              builder: (_, _) => const EmptyModuleScreen(
                title: 'Payments',
                icon: Icons.receipt_long,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.notices,
              builder: (_, _) => const EmptyModuleScreen(
                title: 'Notices',
                icon: Icons.campaign,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, _) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
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
