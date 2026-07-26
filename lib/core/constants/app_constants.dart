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
  static const billing = '/billing';
  static const notices = '/notices';
  static const profile = '/profile';

  // Modules reachable from the home grid. Only the Account tab has real data
  // today; these open an empty state until their module is built.
  static const services = '/home/services';
  static const complaints = '/home/complaints';
  static const guests = '/home/guests';
  static const staff = '/home/staff';
  static const family = '/home/family';
  static const vehicles = '/home/vehicles';
}
