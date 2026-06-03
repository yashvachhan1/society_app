import 'package:flutter/material.dart';

/// A domestic staff member (maid, driver, cook…) registered to a flat, with
/// today's attendance status and this month's attendance summary.
class StaffMember {
  const StaffMember({
    required this.name,
    required this.role,
    required this.phone,
    required this.timings,
    required this.status,
    required this.icon,
    required this.daysPresent,
    required this.totalDays,
    this.checkIn,
    this.checkOut,
  });

  final String name;
  final String role;
  final String phone;
  final String timings;
  final String status;
  final IconData icon;
  final int daysPresent;
  final int totalDays;
  final String? checkIn;
  final String? checkOut;

  bool get isPresent => status == 'Present';

  double get attendanceFraction =>
      totalDays == 0 ? 0 : daysPresent / totalDays;
}
