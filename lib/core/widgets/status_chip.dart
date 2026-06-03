import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A small rounded pill used for statuses, priorities and tags throughout the
/// app (e.g. Urgent, In Progress, Present, Verified). A single source of truth
/// for status colors keeps every screen consistent and removes duplication.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.color});

  /// Builds a chip whose color is derived from a well-known status string.
  factory StatusChip.forStatus(String status, {Key? key}) {
    return StatusChip(key: key, label: status, color: colorForStatus(status));
  }

  final String label;
  final Color color;

  static Color colorForStatus(String status) {
    switch (status.toLowerCase().trim()) {
      case 'urgent':
      case 'overdue':
      case 'absent':
      case 'denied':
        return AppColors.error;
      case 'important':
      case 'in progress':
      case 'assigned':
      case 'pending':
      case 'scheduled':
        return AppColors.warning;
      case 'completed':
      case 'resolved':
      case 'paid':
      case 'present':
      case 'verified':
      case 'approved':
        return AppColors.success;
      case 'submitted':
      case 'normal':
      case 'open':
        return AppColors.primary;
      case 'events':
      case 'event':
        return AppColors.accent;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
