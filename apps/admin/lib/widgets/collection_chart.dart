import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';

/// Monthly maintenance-collection bar chart (last 6 months). The current month
/// is highlighted in solid primary blue, earlier months are muted.
class CollectionChart extends StatelessWidget {
  const CollectionChart({super.key});

  static const _data = DemoData.collections;
  static const _maxY = 500.0;
  static const _step = 100.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: BarChart(
        BarChartData(
          maxY: _maxY,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _step,
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
                interval: _step,
                reservedSize: 38,
                getTitlesWidget: _leftLabel,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: _bottomLabel,
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < _data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: _data[i].amount,
                    width: 26,
                    color: i == _data.length - 1
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

  static Widget _leftLabel(double value, TitleMeta meta) {
    return Text(
      '₹${(value / 100).toStringAsFixed(0)}L',
      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
    );
  }

  static Widget _bottomLabel(double value, TitleMeta meta) {
    final i = value.toInt();
    if (i < 0 || i >= _data.length) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        _data[i].month,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
