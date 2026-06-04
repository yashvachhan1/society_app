import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import 'onboarding_view.dart';
import 'overview_view.dart';
import 'societies_view.dart';

/// Root of the owner / super-admin console: the shared [DashboardShell] wired
/// with the platform branding, navigation and pages. Overview + Societies are
/// built; the rest show a placeholder.
class OwnerShell extends StatelessWidget {
  const OwnerShell({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      brandTitle: DemoData.platformName,
      brandSubtitle: 'Owner Console',
      brandLogo: const SkylineLogo(size: 44, radius: 12),
      navItems: DemoData.navItems,
      userInitials: 'YV',
      userName: DemoData.ownerName,
      userRole: DemoData.ownerRole,
      pageBuilder: (context, i) {
        switch (i) {
          case 0:
            return const OverviewView();
          case 1:
            return const SocietiesView();
          case 3:
            return const OnboardingView();
          default:
            return ComingSoon(
              label: DemoData.navItems[i].label,
              icon: DemoData.navItems[i].icon,
            );
        }
      },
    );
  }
}
