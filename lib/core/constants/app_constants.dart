class AppConstants {
  static const appName = 'Society App';
  static const appVersion = '1.0.0';
}

class AppRoutes {
  // Onboarding (outside the bottom-nav shell)
  static const splash = '/';
  static const language = '/language';
  static const register = '/register';
  static const login = '/login';
  static const otp = '/otp';

  /// Shown while an admin approves the resident's registration
  /// (`memberships.status = 'pending'`).
  static const pendingApproval = '/pending-approval';

  // Bottom navigation tabs
  static const home = '/home';
  static const profile = '/profile';
}
