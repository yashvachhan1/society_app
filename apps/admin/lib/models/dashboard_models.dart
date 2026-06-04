import 'package:flutter/material.dart';

/// A sidebar navigation destination.
class AdminNavItem {
  const AdminNavItem({required this.icon, required this.label, this.badge});

  final IconData icon;
  final String label;

  /// Optional count badge (e.g. open complaints). `null` hides the badge.
  final int? badge;
}

/// A KPI tile shown across the top of the dashboard.
class AdminStat {
  const AdminStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  /// Short trend caption, e.g. "+12 new" or "87% target".
  final String trend;

  /// Whether the trend is positive (green) or needs attention (amber).
  final bool trendUp;
}

/// A resident or tenant awaiting admin approval.
class PendingApproval {
  const PendingApproval({
    required this.name,
    required this.flat,
    required this.type,
    required this.requestedAgo,
  });

  final String name;
  final String flat;

  /// "Owner" or "Tenant".
  final String type;
  final String requestedAgo;
}

/// An entry in the recent-activity feed.
class ActivityItem {
  const ActivityItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
}

/// One month's maintenance collection, used by the bar chart (amount in ₹'000).
class MonthlyCollection {
  const MonthlyCollection(this.month, this.amount);

  final String month;
  final double amount;
}
