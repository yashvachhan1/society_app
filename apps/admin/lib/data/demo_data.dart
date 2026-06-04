import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../models/dashboard_models.dart';

/// Placeholder data for the dashboard while the backend is being built.
/// All of this will later come from the API (society_core/api).
class DemoData {
  const DemoData._();

  static const societyName = 'Sunrise Residency';
  static const adminName = 'Anil Kapoor';
  static const adminRole = 'Society Admin';

  static const navItems = <AdminNavItem>[
    AdminNavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    AdminNavItem(icon: Icons.people_alt_rounded, label: 'Residents'),
    AdminNavItem(icon: Icons.receipt_long_rounded, label: 'Billing'),
    AdminNavItem(
      icon: Icons.build_circle_rounded,
      label: 'Complaints',
      badge: 14,
    ),
    AdminNavItem(icon: Icons.campaign_rounded, label: 'Notices'),
    AdminNavItem(icon: Icons.directions_walk_rounded, label: 'Visitors'),
    AdminNavItem(icon: Icons.engineering_rounded, label: 'Staff'),
    AdminNavItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  static const stats = <AdminStat>[
    AdminStat(
      label: 'Total Residents',
      value: '248',
      icon: Icons.people_alt_rounded,
      color: AppColors.primary,
      trend: '+12 new',
      trendUp: true,
    ),
    AdminStat(
      label: 'Collected (Jun)',
      value: '₹4.2L',
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.success,
      trend: '87% target',
      trendUp: true,
    ),
    AdminStat(
      label: 'Pending Dues',
      value: '₹62K',
      icon: Icons.error_outline_rounded,
      color: AppColors.warning,
      trend: '23 flats',
      trendUp: false,
    ),
    AdminStat(
      label: 'Open Complaints',
      value: '14',
      icon: Icons.build_circle_rounded,
      color: AppColors.accent,
      trend: '5 urgent',
      trendUp: false,
    ),
  ];

  static const pendingApprovals = <PendingApproval>[
    PendingApproval(
      name: 'Rahul Sharma',
      flat: 'A-402',
      type: 'Owner',
      requestedAgo: '2h ago',
    ),
    PendingApproval(
      name: 'Priya Mehta',
      flat: 'B-101',
      type: 'Tenant',
      requestedAgo: '5h ago',
    ),
    PendingApproval(
      name: 'Imran Khan',
      flat: 'C-305',
      type: 'Tenant',
      requestedAgo: '1d ago',
    ),
    PendingApproval(
      name: 'Sneha Patil',
      flat: 'A-208',
      type: 'Owner',
      requestedAgo: '2d ago',
    ),
  ];

  static const activity = <ActivityItem>[
    ActivityItem(
      icon: Icons.payments_rounded,
      color: AppColors.success,
      title: 'Payment received',
      subtitle: 'Flat B-204 paid ₹4,850 maintenance',
      time: '10 min ago',
    ),
    ActivityItem(
      icon: Icons.build_circle_rounded,
      color: AppColors.warning,
      title: 'New complaint raised',
      subtitle: 'Water leakage reported in C-105',
      time: '40 min ago',
    ),
    ActivityItem(
      icon: Icons.campaign_rounded,
      color: AppColors.primary,
      title: 'Notice published',
      subtitle: 'Diwali celebration on 30th October',
      time: '2h ago',
    ),
    ActivityItem(
      icon: Icons.person_add_alt_1_rounded,
      color: AppColors.accent,
      title: 'New registration',
      subtitle: 'Rahul Sharma requested access to A-402',
      time: '2h ago',
    ),
  ];

  static const collections = <MonthlyCollection>[
    MonthlyCollection('Jan', 380),
    MonthlyCollection('Feb', 410),
    MonthlyCollection('Mar', 395),
    MonthlyCollection('Apr', 430),
    MonthlyCollection('May', 405),
    MonthlyCollection('Jun', 420),
  ];
}
