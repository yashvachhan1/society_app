import 'package:flutter/material.dart';

import 'package:society_app/core/theme/app_theme.dart';
import 'package:society_app/core/widgets/widgets.dart';

/// A placeholder for a module that is not built yet.
///
/// The home grid keeps every module tile visible so the shape of the product is
/// clear, but only the profile area has real data today — the rest open this
/// empty state instead of a half-built screen.
class EmptyModuleScreen extends StatelessWidget {
  const EmptyModuleScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: EmptyState(
            icon: icon,
            title: 'Nothing here yet',
            message: '$title will be available in a later release.',
          ),
        ),
      ),
    );
  }
}
