import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import '../widgets/society_tile.dart';

/// The full list of societies on the platform — the heart of the owner console.
class SocietiesView extends StatelessWidget {
  const SocietiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      builder: (context, width) => SectionCard(
        title: 'All Societies',
        action: const _AddButton(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Showing ${DemoData.societies.length} of 487 societies',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            for (var i = 0; i < DemoData.societies.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: SocietyRow(society: DemoData.societies[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text('Add Society'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
