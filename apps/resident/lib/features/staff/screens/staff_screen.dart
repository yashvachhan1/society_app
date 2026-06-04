import 'package:flutter/material.dart';

import 'package:society_core/theme/app_theme.dart';
import 'package:society_core/widgets/widgets.dart';
import '../models/staff_member.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  static const List<StaffMember> _staffList = [
    StaffMember(
      name: 'Sunita Devi',
      role: 'Maid',
      phone: '+91 98765 43210',
      timings: '7:00 AM – 9:00 AM',
      status: 'Present',
      checkIn: '7:03 AM',
      icon: Icons.cleaning_services_outlined,
      daysPresent: 22,
      totalDays: 25,
    ),
    StaffMember(
      name: 'Ramesh Kumar',
      role: 'Driver',
      phone: '+91 91234 56789',
      timings: '8:00 AM – 6:00 PM',
      status: 'Absent',
      icon: Icons.directions_car_outlined,
      daysPresent: 20,
      totalDays: 25,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Domestic Staff'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddStaffSheet(context),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text(
          'Add Staff',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          const _TodaySummaryBar(staffList: _staffList),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              itemCount: _staffList.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _StaffCard(staff: _staffList[i]),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStaffSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddStaffSheet(),
    );
  }
}

class _TodaySummaryBar extends StatelessWidget {
  const _TodaySummaryBar({required this.staffList});

  final List<StaffMember> staffList;

  @override
  Widget build(BuildContext context) {
    final present = staffList.where((s) => s.isPresent).length;
    final absent = staffList.length - present;

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.today_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          const Text(
            "Today's Attendance",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          StatusChip(label: '$present Present', color: AppColors.success),
          const SizedBox(width: 8),
          StatusChip(label: '$absent Absent', color: AppColors.error),
        ],
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({required this.staff});

  final StaffMember staff;

  @override
  Widget build(BuildContext context) {
    final fraction = staff.attendanceFraction;
    final goodAttendance = fraction >= 0.8;
    final progressColor = goodAttendance ? AppColors.success : AppColors.warning;

    return AppCard(
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StaffAvatar(icon: staff.icon, isPresent: staff.isPresent),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      staff.role,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip.forStatus(staff.status),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DetailChip(icon: Icons.schedule, value: staff.timings),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailChip(
                  icon: Icons.login,
                  value: staff.isPresent
                      ? 'In at ${staff.checkIn}'
                      : 'Not checked in',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This month: ${staff.daysPresent}/${staff.totalDays} days',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(fraction * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _StaffActionButton(
                  icon: Icons.phone_outlined,
                  label: 'Call',
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StaffActionButton(
                  icon: Icons.calendar_today_outlined,
                  label: 'Attendance',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StaffAvatar extends StatelessWidget {
  const _StaffAvatar({required this.icon, required this.isPresent});

  final IconData icon;
  final bool isPresent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary, size: 26),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: isPresent ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffActionButton extends StatelessWidget {
  const _StaffActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _AddStaffSheet extends StatelessWidget {
  const _AddStaffSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Add Staff Member',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Role',
              prefixIcon: Icon(Icons.work_outline),
            ),
            items: const [
              DropdownMenuItem(value: 'Maid', child: Text('Maid')),
              DropdownMenuItem(value: 'Driver', child: Text('Driver')),
              DropdownMenuItem(value: 'Cook', child: Text('Cook')),
              DropdownMenuItem(value: 'Security', child: Text('Security')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          const TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add Staff'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
