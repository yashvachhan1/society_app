import 'package:flutter/material.dart';

/// A sidebar navigation destination for a web dashboard (admin or owner panel).
class DashNavItem {
  const DashNavItem({required this.icon, required this.label, this.badge});

  final IconData icon;
  final String label;

  /// Optional count badge (e.g. open complaints, pending societies). Null hides it.
  final int? badge;
}
