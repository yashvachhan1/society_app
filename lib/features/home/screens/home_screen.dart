import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../models/home_module.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<HomeModule> _modules = [
    HomeModule(icon: Icons.receipt_long, label: 'Billing', color: Color(0xFF1565C0), route: AppRoutes.billing),
    HomeModule(icon: Icons.campaign, label: 'Notices', color: Color(0xFF6A1B9A), route: AppRoutes.notices),
    HomeModule(icon: Icons.build_circle, label: 'Complaints', color: Color(0xFFE65100), route: AppRoutes.complaints),
    HomeModule(icon: Icons.qr_code_scanner, label: 'Guests', color: Color(0xFF00695C), route: AppRoutes.guests),
    HomeModule(icon: Icons.people, label: 'Staff', color: Color(0xFF37474F), route: AppRoutes.staff),
    HomeModule(icon: Icons.warning_amber, label: 'Alerts', color: Color(0xFFC62828), route: AppRoutes.alerts),
    HomeModule(icon: Icons.family_restroom, label: 'Family', color: Color(0xFF2E7D32), route: AppRoutes.family),
    HomeModule(icon: Icons.directions_car, label: 'Vehicles', color: Color(0xFF4527A0), route: AppRoutes.vehicles),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(background: _HomeHeader()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _DueCard(amount: 4850, dueDate: '10 June'),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Services'),
                  const SizedBox(height: 16),
                  const _ModuleGrid(modules: _modules),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Recent Notices',
                    actionLabel: 'See all',
                    onAction: () => context.go(AppRoutes.notices),
                  ),
                  const SizedBox(height: 12),
                  const _MiniNoticeCard(
                    title: 'Water Supply Shutdown',
                    description: 'No water on 5th June from 10 AM to 2 PM',
                    priority: 'Urgent',
                    time: '2h ago',
                  ),
                  const SizedBox(height: 10),
                  const _MiniNoticeCard(
                    title: 'Society Meeting',
                    description: 'Monthly meeting on Sunday at 11 AM in the clubhouse',
                    priority: 'Important',
                    time: '1d ago',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primaryLight],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning!',
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                      SizedBox(height: 4),
                      Text('Rahul Sharma',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 4),
                      _FlatBadge(),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.profile),
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlatBadge extends StatelessWidget {
  const _FlatBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text('Flat 301 • Owner',
          style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({required this.amount, required this.dueDate});

  final int amount;
  final String dueDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF00ACC1), Color(0xFF00838F)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00ACC1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('June 2026 Dues',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                formatRupees(amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Due: $dueDate',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.billing),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF00838F),
              minimumSize: const Size(90, 42),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({required this.modules});

  final List<HomeModule> modules;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: modules.length,
      itemBuilder: (_, i) => _ModuleTile(module: modules[i]),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module});

  final HomeModule module;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(module.route),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: module.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(module.icon, color: module.color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            module.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniNoticeCard extends StatelessWidget {
  const _MiniNoticeCard({
    required this.title,
    required this.description,
    required this.priority,
    required this.time,
  });

  final String title;
  final String description;
  final String priority;
  final String time;

  @override
  Widget build(BuildContext context) {
    final color = StatusChip.colorForStatus(priority);
    return AppCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 12,
      onTap: () => context.go(AppRoutes.notices),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip(label: priority, color: color),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
