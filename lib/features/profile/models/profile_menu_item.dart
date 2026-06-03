import 'package:flutter/material.dart';

/// An entry in the profile settings list.
class ProfileMenuItem {
  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
}
