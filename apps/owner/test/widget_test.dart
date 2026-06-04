import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_owner/main.dart';

/// Widget tests for the owner console. A desktop-sized surface keeps the wide
/// layout (sidebar + 4-column stats) overflow-free, with Google Fonts fetching
/// disabled for determinism.
void main() {
  void useDesktopSurface(WidgetTester tester) {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('overview shows platform KPIs', (tester) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const OwnerApp());
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('Welcome back'), findsOneWidget);
    expect(find.text('Total Societies'), findsOneWidget);
    expect(find.text('Monthly Revenue'), findsOneWidget);
  });

  testWidgets('societies tab lists all societies', (tester) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const OwnerApp());
    await tester.pump();

    await tester.tap(find.text('Societies'));
    await tester.pumpAndSettle();

    expect(find.text('All Societies'), findsOneWidget);
    expect(find.text('Sunrise Residency'), findsWidgets);
  });

  testWidgets('narrow layout opens the sidebar from a hamburger', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const OwnerApp());
    await tester.pump();

    final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold));
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(scaffold.isDrawerOpen, isFalse);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    expect(scaffold.isDrawerOpen, isTrue);
  });
}
