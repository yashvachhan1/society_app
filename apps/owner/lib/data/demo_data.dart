import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../models/owner_models.dart';

/// Placeholder platform data for the owner console while the backend is built.
/// All of this will later come from the API (aggregated across every property).
class DemoData {
  const DemoData._();

  static const platformName = 'PropManage';
  static const ownerName = 'Yash Vachhan';
  static const ownerRole = 'Platform Owner';

  static const navItems = <DashNavItem>[
    DashNavItem(icon: Icons.space_dashboard_rounded, label: 'Overview'),
    DashNavItem(icon: Icons.apartment_rounded, label: 'Properties'),
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
      label: 'Total Properties',
      value: '487',
      icon: Icons.domain_rounded,
      color: AppColors.primary,
      trend: '+18 new',
      trendUp: true,
    ),
    PlatformStat(
      label: 'Total Members',
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

  /// The kinds of property the platform can run — society is just one of them.
  static const propertyTypes = <PropertyType>[
    PropertyType(
      name: 'Residential Society',
      icon: Icons.apartment_rounded,
      unitLabel: 'Flats',
      description: 'Apartments & villas — owners and tenants',
    ),
    PropertyType(
      name: 'Corporate Park',
      icon: Icons.corporate_fare_rounded,
      unitLabel: 'Wings / Offices',
      description: 'Office wings & companies — employees',
    ),
    PropertyType(
      name: 'Commercial Complex',
      icon: Icons.storefront_rounded,
      unitLabel: 'Units',
      description: 'Shops & offices — businesses',
    ),
  ];

  /// Every service the platform offers. Each property turns on only what it
  /// needs (modular — a small society may want just a few).
  static const serviceModules = <ServiceModule>[
    ServiceModule(
      name: 'Maintenance & Billing',
      icon: Icons.receipt_long_rounded,
      description: 'Dues, invoices, online payments',
    ),
    ServiceModule(
      name: 'Complaints / Helpdesk',
      icon: Icons.build_circle_rounded,
      description: 'Raise & track issues',
    ),
    ServiceModule(
      name: 'Visitor Management',
      icon: Icons.directions_walk_rounded,
      description: 'Gate entry, pre-approve guests',
    ),
    ServiceModule(
      name: 'Notices & Circulars',
      icon: Icons.campaign_rounded,
      description: 'Announcements to everyone',
    ),
    ServiceModule(
      name: 'Staff Management',
      icon: Icons.engineering_rounded,
      description: 'Attendance & payroll',
    ),
    ServiceModule(
      name: 'Amenity Booking',
      icon: Icons.event_available_rounded,
      description: 'Clubhouse, hall, courts',
    ),
    ServiceModule(
      name: 'Parking & Vehicles',
      icon: Icons.directions_car_rounded,
      description: 'Slots & vehicle passes',
    ),
    ServiceModule(
      name: 'Home Services',
      icon: Icons.handyman_rounded,
      description: 'Electrician, plumber on demand',
      onByDefault: false,
    ),
    ServiceModule(
      name: 'Security & Alerts',
      icon: Icons.shield_rounded,
      description: 'SOS & panic alerts',
    ),
    ServiceModule(
      name: 'Accounting & Reports',
      icon: Icons.account_balance_rounded,
      description: 'Ledgers & audit reports',
      onByDefault: false,
    ),
    ServiceModule(
      name: 'Documents Vault',
      icon: Icons.folder_rounded,
      description: 'Agreements & bylaws',
      onByDefault: false,
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
      type: 'Residential Society',
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
      type: 'Residential Society',
      city: 'Mumbai',
      flats: 420,
      residents: 1640,
      plan: 'Enterprise',
      status: 'Active',
      joined: 'Mar 2024',
      color: AppColors.success,
    ),
    Society(
      name: 'Cyber Heights Corporate Park',
      type: 'Corporate Park',
      city: 'New Delhi',
      flats: 6,
      residents: 4200,
      plan: 'Enterprise',
      status: 'Active',
      joined: 'Apr 2024',
      color: AppColors.primaryDark,
    ),
    Society(
      name: 'Silver Oak Apartments',
      type: 'Residential Society',
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
      type: 'Residential Society',
      city: 'Pune',
      flats: 310,
      residents: 1240,
      plan: 'Enterprise',
      status: 'Active',
      joined: 'Jun 2024',
      color: AppColors.accent,
    ),
    Society(
      name: 'Lake View Towers',
      type: 'Residential Society',
      city: 'Bengaluru',
      flats: 180,
      residents: 720,
      plan: 'Pro',
      status: 'Active',
      joined: 'Jul 2024',
      color: AppColors.primary,
    ),
    Society(
      name: 'City Square Mall',
      type: 'Commercial Complex',
      city: 'Ahmedabad',
      flats: 180,
      residents: 540,
      plan: 'Pro',
      status: 'Trial',
      joined: 'Aug 2024',
      color: AppColors.accent,
    ),
    Society(
      name: 'Maple Court',
      type: 'Residential Society',
      city: 'Chennai',
      flats: 72,
      residents: 280,
      plan: 'Basic',
      status: 'Suspended',
      joined: 'Sep 2024',
      color: AppColors.error,
    ),
  ];
}
