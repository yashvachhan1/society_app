import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../models/complaint.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  static const List<Complaint> _complaints = [
    Complaint(
      id: 'CMP-2025-018',
      title: 'Elevator Not Working',
      description:
          'Elevator in Tower B has been out of service since yesterday morning.',
      category: 'Lift',
      status: 'In Progress',
      date: '5 May 2025',
      icon: Icons.elevator,
    ),
    Complaint(
      id: 'CMP-2025-015',
      title: 'Water Leakage in Corridor',
      description:
          'There is a water leakage near flat 204 corridor causing inconvenience.',
      category: 'Plumbing',
      status: 'Submitted',
      date: '2 May 2025',
      icon: Icons.water_drop_outlined,
    ),
    Complaint(
      id: 'CMP-2025-009',
      title: 'Street Light Not Working',
      description:
          'Three street lights near the parking area are not functional for over a week.',
      category: 'Electrical',
      status: 'Completed',
      date: '22 Apr 2025',
      icon: Icons.lightbulb_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complaints'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewComplaintSheet(context),
        icon: const Icon(Icons.add),
        label: const Text(
          'New Complaint',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          const _SummaryBar(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: _complaints.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ComplaintCard(complaint: _complaints[i]),
            ),
          ),
        ],
      ),
    );
  }

  void _showNewComplaintSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _NewComplaintSheet(),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: const Row(
        children: [
          _SummaryChip(label: 'Total', count: 3, color: AppColors.primary),
          SizedBox(width: 10),
          _SummaryChip(label: 'Open', count: 2, color: AppColors.warning),
          SizedBox(width: 10),
          _SummaryChip(label: 'Resolved', count: 1, color: AppColors.success),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final statusColor = StatusChip.colorForStatus(complaint.status);
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(complaint.icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      complaint.id,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconChip(
                label: complaint.status,
                icon: complaint.statusIcon,
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            complaint.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  complaint.category,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.calendar_today_outlined,
                  size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                complaint.date,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewComplaintSheet extends StatelessWidget {
  const _NewComplaintSheet();

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
            'New Complaint',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Complaint Title',
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: const [
              DropdownMenuItem(value: 'Plumbing', child: Text('Plumbing')),
              DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
              DropdownMenuItem(value: 'Lift', child: Text('Lift')),
              DropdownMenuItem(value: 'Security', child: Text('Security')),
              DropdownMenuItem(value: 'Housekeeping', child: Text('Housekeeping')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Submit Complaint'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
