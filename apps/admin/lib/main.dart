import 'package:flutter/material.dart';

import 'screens/admin_shell.dart';
import 'theme/admin_theme.dart';

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
      theme: AdminTheme.theme,
      home: const AdminShell(),
    );
  }
}
