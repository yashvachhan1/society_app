import 'package:flutter/material.dart';

/// A single notice-board entry. A typed model replaces untyped
/// `Map<String, dynamic>` access and keeps presentation helpers in one place.
class Notice {
  const Notice({
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
    required this.author,
  });

  final String title;
  final String description;
  final String priority;
  final String date;
  final String author;

  IconData get priorityIcon {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Icons.warning_amber_rounded;
      case 'important':
        return Icons.info_outline;
      case 'events':
        return Icons.celebration_outlined;
      default:
        return Icons.notifications_none;
    }
  }
}
