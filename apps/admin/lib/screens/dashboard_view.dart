import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import '../models/dashboard_models.dart';

/// The dashboard page: greeting, KPI stat row, collection chart + pending
/// approvals side by side, and a recent-activity feed.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      builder: (context, width) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Greeting(),
          const SizedBox(height: 24),
          StatTileGrid(
            tiles: [
              for (final stat in DemoData.stats)
                StatTile(
                  label: stat.label,
                  value: stat.value,
                  icon: stat.icon,
                  color: stat.color,
                  trend: stat.trend,
                  trendUp: stat.trendUp,
                ),
            ],
          ),
          const SizedBox(height: 22),
          _ChartAndApprovals(width: width),
          const SizedBox(height: 22),
          const SectionCard(
            title: 'Recent Activity',
            action: _MutedLabel('View all'),
            child: _ActivityList(),
          ),
        ],
      ),
    );
  }
}

/// KPI tiles that reflow with the available width: four across on a wide
/// monitor, two on a medium window, one when narrow — so the values and labels
/// never get squeezed into mid-word wraps.
/// The collection chart and the pending-approvals card. They sit side by side
/// on a wide layout and stack vertically once the content gets narrow.
class _ChartAndApprovals extends StatelessWidget {
  const _ChartAndApprovals({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final chart = SectionCard(
      title: 'Maintenance Collection',
      action: const _MutedLabel('Last 6 months'),
      child: DashboardBarChart(
        bars: [
          for (final c in DemoData.collections) BarPoint(c.month, c.amount),
        ],
        maxY: 500,
        axisStep: 100,
        leftLabel: (v) => '₹${(v / 100).toStringAsFixed(0)}L',
      ),
    );
    final approvals = SectionCard(
      title: 'Pending Approvals',
      action: _CountChip(count: DemoData.pendingApprovals.length),
      child: const _ApprovalsList(),
    );

    if (width >= 860) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: chart),
            const SizedBox(width: 22),
            Expanded(flex: 2, child: approvals),
          ],
        ),
      );
    }
    return Column(
      children: [chart, const SizedBox(height: 22), approvals],
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Welcome back, Anil 👋',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Here's what's happening in ${DemoData.societyName} today.",
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _MutedLabel extends StatelessWidget {
  const _MutedLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count new',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.warning,
        ),
      ),
    );
  }
}

class _ApprovalsList extends StatelessWidget {
  const _ApprovalsList();

  @override
  Widget build(BuildContext context) {
    final items = DemoData.pendingApprovals;
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Divider(height: 22, color: AppColors.divider),
          _ApprovalRow(item: items[i]),
        ],
      ],
    );
  }
}

class _ApprovalRow extends StatelessWidget {
  const _ApprovalRow({required this.item});

  final PendingApproval item;

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = item.type == 'Owner';
    final typeColor = isOwner ? AppColors.primary : AppColors.accent;
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: typeColor.withValues(alpha: 0.12),
          child: Text(
            _initials(item.name),
            style: TextStyle(
              color: typeColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${item.flat}  •  ${item.type}  •  ${item.requestedAgo}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const _ActionIcon(icon: Icons.check_rounded, color: AppColors.success),
        const SizedBox(width: 8),
        const _ActionIcon(icon: Icons.close_rounded, color: AppColors.error),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList();

  @override
  Widget build(BuildContext context) {
    final items = DemoData.activity;
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Divider(height: 24, color: AppColors.divider),
          _ActivityRow(item: items[i]),
        ],
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(item.icon, size: 20, color: item.color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          item.time,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
