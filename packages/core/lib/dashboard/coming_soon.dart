import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Placeholder shown for dashboard sections that are not built yet. Shared by
/// the admin and owner panels.
class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key, required this.label, required this.icon});

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
