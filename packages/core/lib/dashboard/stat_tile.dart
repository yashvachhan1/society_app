import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'dashboard_card.dart';

/// A KPI tile: a coloured icon, a trend indicator, the big value and a label.
/// On narrow cards the trend collapses to just its arrow so nothing overflows.
/// Generic (primitive inputs) so both the admin and owner panels reuse it.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;

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
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 23),
                  ),
                  const Spacer(),
                  _TrendPill(trend: trend, trendUp: trendUp, showText: showTrendText),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
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
                label,
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
  const _TrendPill({
    required this.trend,
    required this.trendUp,
    required this.showText,
  });

  final String trend;
  final bool trendUp;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final color = trendUp ? AppColors.success : AppColors.warning;
    final icon = trendUp
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
              trend,
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
