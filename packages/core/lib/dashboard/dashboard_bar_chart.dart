import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// One bar in a [DashboardBarChart].
class BarPoint {
  const BarPoint(this.label, this.value);

  final String label;
  final double value;
}

/// A simple monthly bar chart for dashboards. The last (current) bar is solid
/// primary blue; earlier bars are muted. [leftLabel] formats the y-axis values.
/// Shared by the admin (collection) and owner (revenue) panels.
class DashboardBarChart extends StatelessWidget {
  const DashboardBarChart({
    super.key,
    required this.bars,
    required this.maxY,
    required this.axisStep,
    required this.leftLabel,
    this.height = 230,
  });

  final List<BarPoint> bars;
  final double maxY;
  final double axisStep;
  final String Function(double value) leftLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: axisStep,
            getDrawingHorizontalLine: (value) =>
                const FlLine(color: AppColors.divider, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: axisStep,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  leftLabel(value),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= bars.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      bars[i].label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < bars.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: bars[i].value,
                    width: 26,
                    color: i == bars.length - 1
                        ? AppColors.primary
                        : AppColors.primaryLight.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
