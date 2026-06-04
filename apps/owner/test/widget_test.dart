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
    expect(find.text('Total Properties'), findsOneWidget);
    expect(find.text('Monthly Revenue'), findsOneWidget);
  });

  testWidgets('properties tab lists all properties', (tester) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const OwnerApp());
    await tester.pump();

    await tester.tap(find.text('Properties'));
    await tester.pumpAndSettle();

    expect(find.text('All Properties'), findsOneWidget);
    expect(find.text('Sunrise Residency'), findsWidgets);
  });

  testWidgets('onboarding offers property types and modular services', (
    tester,
  ) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const OwnerApp());
    await tester.pump();

    await tester.tap(find.text('Onboarding'));
    await tester.pumpAndSettle();

    // Multiple property types — not just societies.
    expect(find.text('Onboard a new property'), findsOneWidget);
    expect(find.text('Residential Society'), findsWidgets);
    expect(find.text('Corporate Park'), findsWidgets);

    // 8 of 11 services on by default; toggling one updates the live count.
    expect(find.text('8 of 11 enabled'), findsOneWidget);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(find.text('8 of 11 enabled'), findsNothing);
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

  testWidgets('Add Property jumps to the onboarding flow', (tester) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const OwnerApp());
    await tester.pump();

    await tester.tap(find.text('Properties'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Property'));
    await tester.pumpAndSettle();

    // Both entry points lead to the one onboarding flow.
    expect(find.text('Onboard a new property'), findsOneWidget);
  });

  testWidgets('support desk lists app tickets and filters them', (
    tester,
  ) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const OwnerApp());
    await tester.pump();

    await tester.tap(find.text('Support'));
    await tester.pumpAndSettle();

    expect(find.text('Support desk'), findsOneWidget);
    expect(find.text('Open Tickets'), findsOneWidget);
    // A resolved ticket is visible under the "All" filter.
    expect(find.text('Dashboard loads very slowly'), findsOneWidget);

    // Filtering to Open hides the resolved ticket.
    await tester.tap(find.text('Open  3'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard loads very slowly'), findsNothing);
  });
}
