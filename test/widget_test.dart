// Basic smoke test for the Society App.
//
// Verifies the app boots into the splash and flows to the login screen.

import 'package:flutter_test/flutter_test.dart';

import 'package:society_app/main.dart';

void main() {
  testWidgets('App boots, shows splash, then login', (WidgetTester tester) async {
    await tester.pumpWidget(const SocietyApp());

    // Splash screen shows the app branding.
    expect(find.text('Society App'), findsOneWidget);
    expect(find.text('Smart Society Management'), findsOneWidget);

    // Let the splash auto-navigation timer fire, then settle on login.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back 👋'), findsOneWidget);
  });
}
