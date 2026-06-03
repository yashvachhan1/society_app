// Basic smoke test for the Society App.
//
// Verifies the app boots and shows the splash screen branding.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:society_app/main.dart';

void main() {
  testWidgets('App boots and shows splash branding', (WidgetTester tester) async {
    await tester.pumpWidget(const SocietyApp());

    // Splash screen shows the app name.
    expect(find.text('Society App'), findsOneWidget);
    expect(find.byIcon(Icons.apartment), findsOneWidget);
  });
}
