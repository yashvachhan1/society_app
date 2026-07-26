import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A record field shown as a tinted icon square, a small label and its value.
/// This is the app's standard way of displaying data read from the backend —
/// used for account, membership, flat and society details.
class IconDetailRow extends StatelessWidget {
  const IconDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isPlaceholder = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  /// Greys the value out when the field is empty (e.g. "Not added").
  final bool isPlaceholder;

  /// When set the row becomes tappable and shows a chevron — used for the
  /// fields the resident can edit in place (photo, language).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = _content();
    if (onTap == null) return row;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: row,
      ),
    );
  }

  Widget _content() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isPlaceholder
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
      ],
    );
  }
}

/// A titled card holding a list of [IconDetailRow]s with dividers between them —
/// the "Contact Details" style block used across the app.
class DetailCard extends StatelessWidget {
  const DetailCard({super.key, required this.title, required this.rows});

  final String title;
  final List<IconDetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(color: AppColors.divider, height: 16),
            rows[i],
          ],
        ],
      ),
    );
  }
}
