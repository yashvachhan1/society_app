import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_admin/main.dart';

/// Widget tests for the admin dashboard. We give the test surface a desktop
/// size so the wide layout (sidebar + 4-column stat row) lays out without
/// overflow, and disable Google Fonts network fetching for determinism.
void main() {
  void useDesktopSurface(WidgetTester tester) {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('renders the dashboard with greeting and KPI stats', (
    tester,
  ) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const AdminApp());
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('Welcome back'), findsOneWidget);
    expect(find.text('Total Residents'), findsOneWidget);
    expect(find.text('Open Complaints'), findsOneWidget);
  });

  testWidgets('sidebar navigation opens another module', (tester) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const AdminApp());
    await tester.pump();

    await tester.tap(find.text('Residents'));
    await tester.pumpAndSettle();

    expect(find.text('Residents module'), findsOneWidget);
  });

  testWidgets('on a narrow layout the sidebar opens from a hamburger', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AdminApp());
    await tester.pump();

    final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold));

    // Narrow layout: the hamburger is shown and the drawer starts closed.
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(scaffold.isDrawerOpen, isFalse);

    // Tapping the hamburger opens the navigation drawer.
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    expect(scaffold.isDrawerOpen, isTrue);
  });
}
