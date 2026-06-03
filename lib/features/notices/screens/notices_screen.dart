import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  String _selectedFilter = 'All';

  static const List<String> _filters = ['All', 'Important', 'Urgent', 'Events'];

  static const List<Map<String, dynamic>> _notices = [
    {
      'title': 'Water Supply Interruption',
      'description':
          'Water supply will be interrupted on 8th May from 9 AM to 2 PM due to pipeline maintenance work on the main road.',
      'priority': 'Urgent',
      'date': '6 May 2025',
      'author': 'Society Secretary',
    },
    {
      'title': 'Annual General Meeting',
      'description':
          'The AGM for FY 2024-25 is scheduled on 15th May at 6:30 PM in the community hall. All residents are requested to attend.',
      'priority': 'Important',
      'date': '4 May 2025',
      'author': 'Managing Committee',
    },
    {
      'title': 'Summer Fest 2025',
      'description':
          'Join us for the annual Summer Fest on 20th May! Fun activities for kids and adults, cultural programs, food stalls and much more.',
      'priority': 'Events',
      'date': '2 May 2025',
      'author': 'Events Committee',
    },
    {
      'title': 'Parking Rules Reminder',
      'description':
          'Residents are reminded not to park vehicles in visitor slots or fire exit zones. Violating vehicles will be towed without notice.',
      'priority': 'Important',
      'date': '28 Apr 2025',
      'author': 'Security Office',
    },
  ];

  List<Map<String, dynamic>> get _filteredNotices {
    if (_selectedFilter == 'All') return _notices;
    return _notices
        .where((n) => n['priority'] == _selectedFilter)
        .toList();
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'Urgent':
        return AppColors.error;
      case 'Important':
        return AppColors.warning;
      case 'Events':
        return AppColors.accent;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _priorityIcon(String priority) {
    switch (priority) {
      case 'Urgent':
        return Icons.warning_amber_rounded;
      case 'Important':
        return Icons.info_outline;
      case 'Events':
        return Icons.celebration_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notice Board'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _filteredNotices.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _filteredNotices.length,
                    itemBuilder: (context, index) =>
                        _NoticeCard(
                          notice: _filteredNotices[index],
                          priorityColor: _priorityColor(
                            _filteredNotices[index]['priority'] as String,
                          ),
                          priorityIcon: _priorityIcon(
                            _filteredNotices[index]['priority'] as String,
                          ),
                        ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final selected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: selected,
                onSelected: (_) => setState(() => _selectedFilter = filter),
                backgroundColor: Colors.white,
                selectedColor: AppColors.primary.withValues(alpha: 0.12),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
                side: BorderSide(
                  color: selected ? AppColors.primary : AppColors.divider,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none,
              size: 60, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'No $_selectedFilter notices',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Map<String, dynamic> notice;
  final Color priorityColor;
  final IconData priorityIcon;

  const _NoticeCard({
    required this.notice,
    required this.priorityColor,
    required this.priorityIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(priorityIcon,
                                size: 13, color: priorityColor),
                            const SizedBox(width: 4),
                            Text(
                              notice['priority'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: priorityColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        notice['date'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    notice['title'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notice['description'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        notice['author'] as String,
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
      ),
    );
  }
}
