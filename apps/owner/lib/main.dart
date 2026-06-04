import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import 'screens/owner_shell.dart';

void main() {
  runApp(const OwnerApp());
}

/// Society Management — Owner / Super-Admin Console.
///
/// A Flutter web app (separate from the per-society admin panel) for the
/// platform owner: manage all societies, subscriptions and onboarding. Shares
/// the same design system via the `society_core` package in this monorepo.
class OwnerApp extends StatelessWidget {
  const OwnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PropManage — Owner Console',
      debugShowCheckedModeBanner: false,
      theme: DashboardTheme.theme,
      home: const OwnerShell(),
    );
  }
}
