import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:society_app/core/constants/app_constants.dart';
import 'package:society_app/core/data/demo_data.dart';
import 'package:society_app/core/models/models.dart';
import 'package:society_app/core/theme/app_theme.dart';
import 'package:society_app/core/utils/formatters.dart';
import 'package:society_app/core/widgets/widgets.dart';

/// The resident's dashboard.
///
/// Every value on this screen comes from a database record: the signed-in
/// `users` row, their `memberships` row, and the `units` / `towers` /
/// `societies` rows those point at.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DemoData.signedInUser;
    final membership = DemoData.currentMembership;
    final society = DemoData.currentSociety;
    final unit = DemoData.currentUnit;
    final tower = DemoData.currentTower;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _HomeHeader(
            user: user,
            membership: membership,
            unit: unit,
            tower: tower,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const SectionHeader(title: 'My Flat'),
                  const SizedBox(height: 12),
                  _FlatCard(unit: unit, tower: tower),
                  const SizedBox(height: 22),
                  const SectionHeader(title: 'My Society'),
                  const SizedBox(height: 12),
                  _SocietyCard(society: society),
                  const SizedBox(height: 22),
                  const SectionHeader(title: 'Membership'),
                  const SizedBox(height: 12),
                  _MembershipCard(membership: membership),
                  const SizedBox(height: 8),
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
  const _HomeHeader({
    required this.user,
    required this.membership,
    required this.unit,
    required this.tower,
  });

  final AppUser user;
  final Membership membership;
  final Unit unit;
  final Tower tower;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Row(
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
                      label:
                          '${unit.labelWith(tower)} • ${membership.role.label}',
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.profile),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white24,
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

/// The `units` record: number, wing, floor, type, carpet area, parking.
class _FlatCard extends StatelessWidget {
  const _FlatCard({required this.unit, required this.tower});

  final Unit unit;
  final Tower tower;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Flat Details',
      rows: [
        IconDetailRow(
          icon: Icons.home_outlined,
          label: 'Flat number',
          value: unit.unitNo,
          color: AppColors.primary,
        ),
        IconDetailRow(
          icon: Icons.apartment_outlined,
          label: 'Wing / Tower',
          value: tower.name,
          color: AppColors.accent,
        ),
        IconDetailRow(
          icon: Icons.stairs_outlined,
          label: 'Floor',
          value: '${unit.floor}',
          color: AppColors.success,
        ),
        IconDetailRow(
          icon: Icons.meeting_room_outlined,
          label: 'Unit type',
          value: unit.unitType,
          color: AppColors.warning,
        ),
        IconDetailRow(
          icon: Icons.straighten_outlined,
          label: 'Carpet area',
          value: '${unit.areaSqft.toStringAsFixed(0)} sq.ft',
          color: AppColors.primary,
        ),
        IconDetailRow(
          icon: Icons.local_parking_outlined,
          label: 'Parking slots',
          value: '${unit.parkingSlots}',
          color: AppColors.accent,
        ),
      ],
    );
  }
}

/// The `societies` record: name, registration number, address.
class _SocietyCard extends StatelessWidget {
  const _SocietyCard({required this.society});

  final Society society;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Society Details',
      rows: [
        IconDetailRow(
          icon: Icons.location_city_outlined,
          label: 'Name',
          value: society.name,
          color: AppColors.primary,
        ),
        IconDetailRow(
          icon: Icons.badge_outlined,
          label: 'Registration number',
          value: society.registrationNo,
          color: AppColors.success,
        ),
        IconDetailRow(
          icon: Icons.location_on_outlined,
          label: 'Address',
          value: society.fullAddress,
          color: AppColors.accent,
        ),
      ],
    );
  }
}

/// The `memberships` record: role, status, and when it started.
class _MembershipCard extends StatelessWidget {
  const _MembershipCard({required this.membership});

  final Membership membership;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Membership',
      rows: [
        IconDetailRow(
          icon: Icons.verified_user_outlined,
          label: 'Role',
          value: membership.role.label,
          color: AppColors.primary,
        ),
        IconDetailRow(
          icon: Icons.task_alt_outlined,
          label: 'Status',
          value: membership.status.label,
          color: membership.isActive ? AppColors.success : AppColors.warning,
        ),
        IconDetailRow(
          icon: Icons.event_outlined,
          label: 'Member since',
          value: formatDate(membership.startDate),
          color: AppColors.accent,
        ),
      ],
    );
  }
}
