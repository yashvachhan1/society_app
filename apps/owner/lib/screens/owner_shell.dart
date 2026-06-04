import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import 'onboarding_view.dart';
import 'overview_view.dart';
import 'societies_view.dart';
import 'support_view.dart';

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
        final item = DemoData.navItems[i];
        switch (item.label) {
          case 'Overview':
            return const OverviewView();
          case 'Properties':
            return const SocietiesView();
          case 'Support':
            return const SupportView();
          case 'Onboarding':
            return const OnboardingView();
          default:
            return ComingSoon(label: item.label, icon: item.icon);
        }
      },
    );
  }
}
