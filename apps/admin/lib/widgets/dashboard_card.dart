import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

/// The white rounded card used across the whole dashboard (stat tiles, titled
/// sections, lists). Centralising the decoration here keeps the look identical
/// everywhere and avoids duplicated `BoxDecoration` code (helps the SonarQube
/// duplication score stay at zero).
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
