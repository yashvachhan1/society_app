import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:society_app/core/constants/app_constants.dart';
import 'package:society_app/core/data/demo_data.dart';
import 'package:society_app/core/theme/app_theme.dart';
import 'package:society_app/core/widgets/widgets.dart';

/// The resident's home tab.
///
/// The header identifies who is signed in and which flat they belong to — all
/// of it read from the `users`, `memberships`, `units` and `towers` records.
/// Below that the screen is intentionally empty: billing, notices, complaints
/// and the other modules are not built yet, and nothing is shown that the
/// backend cannot actually provide.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _HomeHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: EmptyState(
                  icon: Icons.inbox_outlined,
                  title: 'Nothing here yet',
                  message:
                      'Bills, notices and complaints will appear here once those '
                      'modules are enabled for your society.',
                ),
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
    final user = DemoData.signedInUser;
    final membership = DemoData.currentMembership;
    final unit = DemoData.currentUnit;
    final tower = DemoData.currentTower;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Morning!',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 3),
              Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              _FlatBadge(
                label: '${unit.labelWith(tower)} • ${membership.role.label}',
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.profile),
          child: PhotoAvatar(
            initials: user.initials,
            photoUrl: user.photoUrl,
            radius: 24,
            onLight: true,
          ),
        ),
      ],
    );
  }
}

class _FlatBadge extends StatelessWidget {
  const _FlatBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
