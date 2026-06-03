import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      {'icon': Icons.receipt_long, 'label': 'Billing', 'color': const Color(0xFF1565C0), 'route': AppRoutes.billing},
      {'icon': Icons.campaign, 'label': 'Notices', 'color': const Color(0xFF6A1B9A), 'route': AppRoutes.notices},
      {'icon': Icons.build_circle, 'label': 'Complaints', 'color': const Color(0xFFE65100), 'route': AppRoutes.complaints},
      {'icon': Icons.qr_code_scanner, 'label': 'Guests', 'color': const Color(0xFF00695C), 'route': AppRoutes.guests},
      {'icon': Icons.people, 'label': 'Staff', 'color': const Color(0xFF37474F), 'route': AppRoutes.staff},
      {'icon': Icons.warning_amber, 'label': 'Alerts', 'color': const Color(0xFFC62828), 'route': AppRoutes.alerts},
      {'icon': Icons.family_restroom, 'label': 'Family', 'color': const Color(0xFF2E7D32), 'route': AppRoutes.family},
      {'icon': Icons.directions_car, 'label': 'Vehicles', 'color': const Color(0xFF4527A0), 'route': AppRoutes.vehicles},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Good Morning!', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                const SizedBox(height: 4),
                                const Text('Rahul Sharma', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('Flat 301 • Owner', style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
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
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DueCard(),
                  const SizedBox(height: 24),
                  const Text('Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: modules.length,
                    itemBuilder: (_, i) => _ModuleTile(
                      icon: modules[i]['icon'] as IconData,
                      label: modules[i]['label'] as String,
                      color: modules[i]['color'] as Color,
                      onTap: () => context.go(modules[i]['route'] as String),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Recent Notices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  _NoticeCard(title: 'Water Supply Shutdown', desc: 'No water on 5th June from 10 AM to 2 PM', priority: 'Urgent', time: '2h ago'),
                  const SizedBox(height: 10),
                  _NoticeCard(title: 'Society Meeting', desc: 'Monthly meeting on Sunday at 11 AM in the clubhouse', priority: 'Important', time: '1d ago'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00ACC1), Color(0xFF00838F)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF00ACC1).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('June 2026 Dues', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 4),
              const Text('₹4,850', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text('Due: 10 June', style: TextStyle(color: Colors.white, fontSize: 12)),
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

class _ModuleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ModuleTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final String title, desc, priority, time;
  const _NoticeCard({required this.title, required this.desc, required this.priority, required this.time});

  @override
  Widget build(BuildContext context) {
    final isUrgent = priority == 'Urgent';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: isUrgent ? AppColors.error : AppColors.warning,
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
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isUrgent ? AppColors.error : AppColors.warning).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(priority, style: TextStyle(fontSize: 10, color: isUrgent ? AppColors.error : AppColors.warning, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
