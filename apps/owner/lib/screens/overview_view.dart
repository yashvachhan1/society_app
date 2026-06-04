import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import '../models/owner_models.dart';
import '../widgets/society_tile.dart';

/// The owner overview: platform-wide KPIs, subscription revenue, plan mix and
/// the most recently onboarded societies.
class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      builder: (context, width) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Greeting(),
          const SizedBox(height: 24),
          _StatsGrid(width: width),
          const SizedBox(height: 22),
          _RevenueAndPlans(width: width),
          const SizedBox(height: 22),
          const _RecentSocieties(),
        ],
      ),
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
          'Welcome back, Yash 👋',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Here is how ${DemoData.platformName} is performing across all societies.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    const gap = 16.0;
    final columns = width >= 1000 ? 4 : 2;
    final cardWidth =
        ((width - gap * (columns - 1)) / columns).floorToDouble();
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final s in DemoData.stats)
          SizedBox(
            width: cardWidth,
            child: StatTile(
              label: s.label,
              value: s.value,
              icon: s.icon,
              color: s.color,
              trend: s.trend,
              trendUp: s.trendUp,
            ),
          ),
      ],
    );
  }
}

class _RevenueAndPlans extends StatelessWidget {
  const _RevenueAndPlans({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final revenue = SectionCard(
      title: 'Subscription Revenue',
      action: const _MutedLabel('Last 6 months'),
      child: DashboardBarChart(
        bars: DemoData.revenue,
        maxY: 600,
        axisStep: 100,
        leftLabel: (v) => '₹${(v / 100).toStringAsFixed(0)}L',
      ),
    );
    const plansCard = SectionCard(
      title: 'Societies by Plan',
      child: _PlanList(),
    );

    if (width >= 860) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: revenue),
            const SizedBox(width: 22),
            const Expanded(flex: 2, child: plansCard),
          ],
        ),
      );
    }
    return Column(
      children: [revenue, const SizedBox(height: 22), plansCard],
    );
  }
}

class _PlanList extends StatelessWidget {
  const _PlanList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < DemoData.plans.length; i++) ...[
          if (i > 0) const SizedBox(height: 18),
          _PlanRow(plan: DemoData.plans[i]),
        ],
      ],
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.plan});

  final PlanBreakdown plan;

  static const _total = 487;

  @override
  Widget build(BuildContext context) {
    final pct = (plan.count / _total * 100).round();
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: plan.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            plan.plan,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          '${plan.count}',
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            '$pct%',
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _RecentSocieties extends StatelessWidget {
  const _RecentSocieties();

  @override
  Widget build(BuildContext context) {
    final recent = DemoData.societies.take(4).toList();
    return SectionCard(
      title: 'Recently Onboarded',
      action: const _MutedLabel('View all'),
      child: Column(
        children: [
          for (var i = 0; i < recent.length; i++) ...[
            if (i > 0) const Divider(height: 24, color: AppColors.divider),
            SocietyRow(society: recent[i]),
          ],
        ],
      ),
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
