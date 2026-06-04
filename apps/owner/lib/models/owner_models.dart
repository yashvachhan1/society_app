import 'package:flutter/material.dart';

/// A platform-wide KPI shown on the owner overview (across all societies).
class PlatformStat {
  const PlatformStat({
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
  final String trend;
  final bool trendUp;
}

/// One society (a tenant of the platform).
class Society {
  const Society({
    required this.name,
    required this.city,
    required this.flats,
    required this.residents,
    required this.plan,
    required this.status,
    required this.joined,
    required this.color,
  });

  final String name;
  final String city;
  final int flats;
  final int residents;

  /// "Basic" | "Pro" | "Enterprise".
  final String plan;

  /// "Active" | "Trial" | "Suspended".
  final String status;
  final String joined;

  /// Avatar tint.
  final Color color;
}

/// How many societies are on each subscription plan (overview breakdown).
class PlanBreakdown {
  const PlanBreakdown({
    required this.plan,
    required this.count,
    required this.color,
  });

  final String plan;
  final int count;
  final Color color;
}
