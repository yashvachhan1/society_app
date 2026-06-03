import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../models/notice.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  static const List<String> _filters = ['All', 'Important', 'Urgent', 'Events'];

  static const List<Notice> _notices = [
    Notice(
      title: 'Water Supply Interruption',
      description:
          'Water supply will be interrupted on 8th May from 9 AM to 2 PM due to pipeline maintenance work on the main road.',
      priority: 'Urgent',
      date: '6 May 2025',
      author: 'Society Secretary',
    ),
    Notice(
      title: 'Annual General Meeting',
      description:
          'The AGM for FY 2024-25 is scheduled on 15th May at 6:30 PM in the community hall. All residents are requested to attend.',
      priority: 'Important',
      date: '4 May 2025',
      author: 'Managing Committee',
    ),
    Notice(
      title: 'Summer Fest 2025',
      description:
          'Join us for the annual Summer Fest on 20th May! Fun activities for kids and adults, cultural programs, food stalls and much more.',
      priority: 'Events',
      date: '2 May 2025',
      author: 'Events Committee',
    ),
    Notice(
      title: 'Parking Rules Reminder',
      description:
          'Residents are reminded not to park vehicles in visitor slots or fire exit zones. Violating vehicles will be towed without notice.',
      priority: 'Important',
      date: '28 Apr 2025',
      author: 'Security Office',
    ),
  ];

  String _selectedFilter = 'All';

  List<Notice> get _filteredNotices {
    if (_selectedFilter == 'All') return _notices;
    return _notices.where((n) => n.priority == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notices = _filteredNotices;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notice Board'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            filters: _filters,
            selected: _selectedFilter,
            onSelect: (f) => setState(() => _selectedFilter = f),
          ),
          Expanded(
            child: notices.isEmpty
                ? EmptyState(
                    icon: Icons.notifications_none,
                    title: 'No $_selectedFilter notices',
                    message: 'New notices from your society will appear here.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: notices.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _NoticeCard(notice: notices[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final filter in filters)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: selected == filter,
                  onSelected: (_) => onSelect(filter),
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.primary.withValues(alpha: 0.12),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected == filter
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: selected == filter
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 13,
                  ),
                  side: BorderSide(
                    color: selected == filter
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.notice});

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    final color = StatusChip.colorForStatus(notice.priority);
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconChip(
                      label: notice.priority,
                      icon: notice.priorityIcon,
                      color: color,
                    ),
                    const Spacer(),
                    Text(
                      notice.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  notice.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notice.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      notice.author,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
