import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../models/owner_models.dart';

/// Placeholder platform data for the owner console while the backend is built.
/// All of this will later come from the API (aggregated across every society).
class DemoData {
  const DemoData._();

  static const platformName = 'PropManage';
  static const ownerName = 'Yash Vachhan';
  static const ownerRole = 'Platform Owner';

  static const navItems = <DashNavItem>[
    DashNavItem(icon: Icons.space_dashboard_rounded, label: 'Overview'),
    DashNavItem(icon: Icons.apartment_rounded, label: 'Societies'),
    DashNavItem(
      icon: Icons.workspace_premium_rounded,
      label: 'Subscriptions',
    ),
    DashNavItem(
      icon: Icons.add_business_rounded,
      label: 'Onboarding',
      badge: 3,
    ),
    DashNavItem(icon: Icons.insights_rounded, label: 'Reports'),
    DashNavItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  static const stats = <PlatformStat>[
    PlatformStat(
      label: 'Total Societies',
      value: '487',
      icon: Icons.apartment_rounded,
      color: AppColors.primary,
      trend: '+18 new',
      trendUp: true,
    ),
    PlatformStat(
      label: 'Total Residents',
      value: '58.2K',
      icon: Icons.groups_rounded,
      color: AppColors.accent,
      trend: '+1.2K',
      trendUp: true,
    ),
    PlatformStat(
      label: 'Monthly Revenue',
      value: '₹4.86L',
      icon: Icons.payments_rounded,
      color: AppColors.success,
      trend: '+9%',
      trendUp: true,
    ),
    PlatformStat(
      label: 'Active Plans',
      value: '462',
      icon: Icons.verified_rounded,
      color: AppColors.warning,
      trend: '25 trial',
      trendUp: false,
    ),
  ];

  /// Monthly subscription revenue in ₹ thousands (last 6 months).
  static const revenue = <BarPoint>[
    BarPoint('Jan', 380),
    BarPoint('Feb', 410),
    BarPoint('Mar', 435),
    BarPoint('Apr', 452),
    BarPoint('May', 470),
    BarPoint('Jun', 486),
  ];

  static const plans = <PlanBreakdown>[
    PlanBreakdown(plan: 'Enterprise', count: 97, color: AppColors.primary),
    PlanBreakdown(plan: 'Pro', count: 248, color: AppColors.accent),
    PlanBreakdown(plan: 'Basic', count: 142, color: AppColors.warning),
  ];

  static const societies = <Society>[
    Society(
      name: 'Sunrise Residency',
      city: 'Pune',
      flats: 240,
      residents: 980,
      plan: 'Pro',
      status: 'Active',
      joined: 'Jan 2024',
      color: AppColors.primary,
    ),
    Society(
      name: 'Green Valley Heights',
      city: 'Mumbai',
      flats: 420,
      residents: 1640,
      plan: 'Enterprise',
      status: 'Active',
      joined: 'Mar 2024',
      color: AppColors.success,
    ),
    Society(
      name: 'Lake View Towers',
      city: 'Bengaluru',
      flats: 180,
      residents: 720,
      plan: 'Pro',
      status: 'Active',
      joined: 'Apr 2024',
      color: AppColors.accent,
    ),
    Society(
      name: 'Silver Oak Apartments',
      city: 'Hyderabad',
      flats: 96,
      residents: 360,
      plan: 'Basic',
      status: 'Trial',
      joined: 'May 2024',
      color: AppColors.warning,
    ),
    Society(
      name: 'Palm Meadows',
      city: 'Pune',
      flats: 310,
      residents: 1240,
      plan: 'Enterprise',
      status: 'Active',
      joined: 'Jun 2024',
      color: AppColors.primaryDark,
    ),
    Society(
      name: 'Royal Enclave',
      city: 'New Delhi',
      flats: 150,
      residents: 600,
      plan: 'Pro',
      status: 'Active',
      joined: 'Jul 2024',
      color: AppColors.accent,
    ),
    Society(
      name: 'Maple Court',
      city: 'Chennai',
      flats: 72,
      residents: 280,
      plan: 'Basic',
      status: 'Suspended',
      joined: 'Aug 2024',
      color: AppColors.error,
    ),
    Society(
      name: 'Orchid Greens',
      city: 'Ahmedabad',
      flats: 200,
      residents: 800,
      plan: 'Pro',
      status: 'Trial',
      joined: 'Sep 2024',
      color: AppColors.warning,
    ),
  ];
}
