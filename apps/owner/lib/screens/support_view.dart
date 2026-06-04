import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import '../models/owner_models.dart';

/// The platform support desk: app issues reported by users across every
/// property land here as tickets (a bug, payment, login problem, etc.).
class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  static const _filters = ['All', 'Open', 'In Progress', 'Resolved'];
  String _filter = 'All';

  List<SupportTicket> get _visible => _filter == 'All'
      ? DemoData.supportTickets
      : DemoData.supportTickets.where((t) => t.status == _filter).toList();

  int _count(String filter) => filter == 'All'
      ? DemoData.supportTickets.length
      : DemoData.supportTickets.where((t) => t.status == filter).length;

  @override
  Widget build(BuildContext context) {
    final tickets = _visible;
    return DashboardPage(
      builder: (context, width) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Intro(),
          const SizedBox(height: 24),
          StatTileGrid(
            tiles: [
              for (final s in DemoData.supportStats)
                StatTile(
                  label: s.label,
                  value: s.value,
                  icon: s.icon,
                  color: s.color,
                  trend: s.trend,
                  trendUp: s.trendUp,
                ),
            ],
          ),
          const SizedBox(height: 22),
          SectionCard(
            title: 'Tickets',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilterBar(
                  filters: _filters,
                  selected: _filter,
                  countOf: _count,
                  onSelect: (f) => setState(() => _filter = f),
                ),
                const SizedBox(height: 16),
                if (tickets.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        'No tickets in this view.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  for (var i = 0; i < tickets.length; i++) ...[
                    if (i > 0)
                      const Divider(height: 1, color: AppColors.divider),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: _TicketRow(ticket: tickets[i]),
                    ),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Support desk',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'App problems reported by users across every property arrive here as tickets.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filters,
    required this.selected,
    required this.countOf,
    required this.onSelect,
  });

  final List<String> filters;
  final String selected;
  final int Function(String filter) countOf;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final f in filters)
          _FilterChip(
            label: f,
            count: countOf(f),
            selected: f == selected,
            onTap: () => onSelect(f),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            '$label  $count',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketRow extends StatelessWidget {
  const _TicketRow({required this.ticket});

  final SupportTicket ticket;

  static Color _priorityColor(String priority) => switch (priority) {
    'Urgent' => AppColors.error,
    'High' => AppColors.warning,
    'Medium' => AppColors.accent,
    _ => AppColors.textSecondary,
  };

  static Color _statusColor(String status) => switch (status) {
    'Open' => AppColors.warning,
    'In Progress' => AppColors.primary,
    _ => AppColors.success,
  };

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(ticket.priority);
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: priorityColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(ticket.icon, size: 21, color: priorityColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '#${ticket.id}  •  ${ticket.user}  •  ${ticket.property}  •  ${ticket.ago}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _Pill(text: ticket.priority, color: priorityColor, filled: false),
        const SizedBox(width: 8),
        _Pill(text: ticket.status, color: _statusColor(ticket.status), filled: true),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color, required this.filled});

  final String text;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: AppColors.divider),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: filled ? color : AppColors.textSecondary,
        ),
      ),
    );
  }
}
