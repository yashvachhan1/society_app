import 'package:flutter/material.dart';

/// A dashboard shortcut tile that routes to a feature module.
class HomeModule {
  const HomeModule({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String route;
}
