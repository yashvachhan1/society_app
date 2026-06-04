import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import 'screens/admin_shell.dart';

void main() {
  runApp(const AdminApp());
}

/// Society Management — Admin Web Dashboard.
///
/// A Flutter web app (separate from the resident mobile app) that shares the
/// same design system via the `society_core` package in this monorepo.
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Society Admin',
      debugShowCheckedModeBanner: false,
      theme: DashboardTheme.theme,
      home: const AdminShell(),
    );
  }
}
