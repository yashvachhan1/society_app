class AppConstants {
  static const appName = 'Society App';
  static const appVersion = '1.0.0';
}

class AppRoutes {
  // Top-level (outside the bottom-nav shell)
  static const splash = '/';
  static const login = '/login';
  static const otp = '/otp';

  // Admin panel (Phase 2 — web dashboard)
  static const admin = '/admin';

  // Bottom navigation tabs
  static const home = '/home';
  static const billing = '/billing';
  static const notices = '/notices';
  static const profile = '/profile';

  // Secondary screens (pushed within the Home tab, bottom nav stays visible)
  static const services = '/home/services';
  static const complaints = '/home/complaints';
  static const guests = '/home/guests';
  static const staff = '/home/staff';
  static const alerts = '/home/alerts';
  static const family = '/home/family';
  static const vehicles = '/home/vehicles';
}
