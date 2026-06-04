import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../models/dashboard_models.dart';
import 'dashboard_card.dart';

/// A single KPI tile: a coloured icon, a trend indicator, the big value and a
/// label. On narrow cards (phone, two-up) the trend collapses to just its arrow
/// so nothing overflows; on wide cards it shows the full trend caption.
class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.stat});

  final AdminStat stat;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showTrendText = constraints.maxWidth >= 150;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: stat.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(stat.icon, color: stat.color, size: 23),
                  ),
                  const Spacer(),
                  _TrendPill(stat: stat, showText: showTrendText),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                stat.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TrendPill extends StatelessWidget {
  const _TrendPill({required this.stat, required this.showText});

  final AdminStat stat;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final color = stat.trendUp ? AppColors.success : AppColors.warning;
    final icon = stat.trendUp
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showText ? 8 : 6,
        vertical: showText ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          if (showText) ...[
            const SizedBox(width: 4),
            Text(
              stat.trend,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
