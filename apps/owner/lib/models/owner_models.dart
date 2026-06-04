import 'package:flutter/material.dart';

/// A platform-wide KPI shown on the owner overview (across all properties).
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

/// A kind of property the platform supports — not just residential societies
/// but also corporate parks (wings/offices), commercial complexes, etc.
class PropertyType {
  const PropertyType({
    required this.name,
    required this.icon,
    required this.unitLabel,
    required this.description,
  });

  final String name;
  final IconData icon;

  /// What a "unit" is called for this type (Flats / Wings / Units).
  final String unitLabel;
  final String description;
}

/// A service/module that can be switched on or off per property, so a tenant
/// only pays for and sees the features they actually need.
class ServiceModule {
  const ServiceModule({
    required this.name,
    required this.icon,
    required this.description,
    this.onByDefault = true,
  });

  final String name;
  final IconData icon;
  final String description;
  final bool onByDefault;
}

/// One property (a tenant of the platform): a society, corporate park, etc.
class Society {
  const Society({
    required this.name,
    required this.type,
    required this.city,
    required this.flats,
    required this.residents,
    required this.plan,
    required this.status,
    required this.joined,
    required this.color,
  });

  final String name;

  /// Property-type name, e.g. "Residential Society" / "Corporate Park".
  final String type;
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

/// How many properties are on each subscription plan (overview breakdown).
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
