import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import 'dashboard_view.dart';

/// Root of the society-admin panel: the shared [DashboardShell] wired with this
/// society's branding, navigation and pages. Only the Dashboard is built so
/// far; the other sections show a tidy placeholder.
class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      brandTitle: DemoData.societyName,
      brandSubtitle: 'Admin Panel',
      brandLogo: const SkylineLogo(size: 44, radius: 12),
      navItems: DemoData.navItems,
      userInitials: 'AK',
      userName: DemoData.adminName,
      userRole: DemoData.adminRole,
      pageBuilder: (context, i) => i == 0
          ? const DashboardView()
          : ComingSoon(
              label: DemoData.navItems[i].label,
              icon: DemoData.navItems[i].icon,
            ),
    );
  }
}
