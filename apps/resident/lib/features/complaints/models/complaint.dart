import 'package:flutter/material.dart';

/// A service/maintenance complaint raised by a resident, tracked through its
/// lifecycle (Submitted → In Progress → Completed).
class Complaint {
  const Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.date,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String date;
  final IconData icon;

  IconData get statusIcon {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'in progress':
        return Icons.autorenew;
      case 'submitted':
        return Icons.send_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
