import 'package:flutter/material.dart';

/// A left-sidebar navigation entry in the admin web dashboard.
class AdminNavItem {
  const AdminNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// A headline metric shown on the admin dashboard.
class AdminStat {
  const AdminStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
}

/// A resident action waiting for the admin (KYC, tenant approval, etc.).
class PendingApproval {
  const PendingApproval({
    required this.name,
    required this.flat,
    required this.type,
    required this.avatar,
  });

  final String name;
  final String flat;
  final String type;
  final String avatar;
}
