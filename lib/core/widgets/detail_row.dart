import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A read-only label/value row inside a card — the standard way this app
/// displays a record's fields (profile details, flat details, society details).
///
/// Rows are separated by a divider unless [isLast] is set.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isLast;

  /// Overrides the value colour, e.g. to grey out a placeholder "—".
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 108,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}
