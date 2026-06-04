import 'package:flutter/material.dart';

import 'package:society_core/theme/app_theme.dart';
import 'package:society_core/widgets/widgets.dart';
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          for (var i = 0; i < filters.length; i++) ...[
            Expanded(
              child: _FilterTab(
                label: filters[i],
                selected: selected == filters[i],
                onTap: () => onSelect(filters[i]),
              ),
            ),
            if (i < filters.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 5, color: color),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                          const SizedBox(height: 12),
                          Text(
                            notice.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
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
                          const SizedBox(height: 14),
                          const Divider(height: 1, color: AppColors.divider),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.account_circle_outlined,
                                  size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Text(
                                notice.author,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
