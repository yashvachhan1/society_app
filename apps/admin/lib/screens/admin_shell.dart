import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/top_bar.dart';
import 'dashboard_view.dart';

/// Root layout: a fixed sidebar on the left and, on the right, a top bar above
/// the selected page. Only the Dashboard is built so far; the other sections
/// show a tidy placeholder so the navigation already works end-to-end.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  /// Below this width the sidebar collapses into a hamburger drawer (phones,
  /// small tablets); above it the sidebar is always visible (desktop).
  static const _wideBreakpoint = 900.0;

  @override
  Widget build(BuildContext context) {
    final item = DemoData.navItems[_index];
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _wideBreakpoint;

        void onSelect(int i) {
          setState(() => _index = i);
          if (!isWide) _scaffoldKey.currentState?.closeDrawer();
        }

        final sidebar = AppSidebar(selectedIndex: _index, onSelect: onSelect);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          drawer: isWide
              ? null
              : Drawer(
                  width: 270,
                  backgroundColor: AppColors.surface,
                  child: sidebar,
                ),
          body: SafeArea(
            child: Row(
              children: [
                if (isWide) sidebar,
                Expanded(
                  child: Column(
                    children: [
                      TopBar(
                        title: item.label,
                        onMenu: isWide
                            ? null
                            : () => _scaffoldKey.currentState?.openDrawer(),
                      ),
                      Expanded(
                        child: _index == 0
                            ? const DashboardView()
                            : _ComingSoon(label: item.label, icon: item.icon),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            '$label module',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'This section is coming soon.',
            style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
