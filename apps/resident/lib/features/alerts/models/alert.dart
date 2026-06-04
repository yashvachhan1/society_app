import 'package:flutter/material.dart';

/// A one-tap quick-alert category a resident can raise (no water, power cut…).
class AlertType {
  const AlertType({
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String description;
}

/// A recently raised alert shown in the activity list.
class RecentAlert {
  const RecentAlert({
    required this.type,
    required this.message,
    required this.time,
    required this.color,
    required this.icon,
  });

  final String type;
  final String message;
  final String time;
  final Color color;
  final IconData icon;
}
