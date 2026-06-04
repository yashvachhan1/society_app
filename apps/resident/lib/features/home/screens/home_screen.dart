import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:society_core/constants/app_constants.dart';
import 'package:society_core/theme/app_theme.dart';
import 'package:society_core/widgets/widgets.dart';
import '../models/home_module.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<HomeModule> _modules = [
    HomeModule(icon: Icons.receipt_long, label: 'Billing', color: Color(0xFF1565C0), route: AppRoutes.billing),
    HomeModule(icon: Icons.campaign, label: 'Notices', color: Color(0xFF6A1B9A), route: AppRoutes.notices),
    HomeModule(icon: Icons.build_circle, label: 'Complaints', color: Color(0xFFE65100), route: AppRoutes.complaints),
    HomeModule(icon: Icons.qr_code_scanner, label: 'Guests', color: Color(0xFF00695C), route: AppRoutes.guests),
    HomeModule(icon: Icons.handyman, label: 'Services', color: Color(0xFF00838F), route: AppRoutes.services),
    HomeModule(icon: Icons.people, label: 'Staff', color: Color(0xFF37474F), route: AppRoutes.staff),
    HomeModule(icon: Icons.family_restroom, label: 'Family', color: Color(0xFF2E7D32), route: AppRoutes.family),
    HomeModule(icon: Icons.directions_car, label: 'Vehicles', color: Color(0xFF4527A0), route: AppRoutes.vehicles),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const _HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const SectionHeader(title: 'Services'),
                  const SizedBox(height: 14),
                  const _ModuleGrid(modules: _modules),
                  const SizedBox(height: 22),
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
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: _HeaderContent(),
        ),
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Morning!',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              SizedBox(height: 3),
              Text('Rahul Sharma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 6),
              _FlatBadge(),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.profile),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 28),
          ),
        ),
      ],
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

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({required this.modules});

  final List<HomeModule> modules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final m in modules.take(4)) _ModuleTile(module: m),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final m in modules.skip(4)) _ModuleTile(module: m),
          ],
        ),
      ],
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
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: module.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(module.icon, color: module.color, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              module.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
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
      borderRadius: 14,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
