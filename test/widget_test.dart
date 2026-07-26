// Boot test for the Society App.
//
// Verifies the app starts on the splash and flows into the language picker,
// the first step of onboarding.

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_app/main.dart';

void main() {
  testWidgets('App boots, shows splash, then the language picker', (
    WidgetTester tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await tester.pumpWidget(const SocietyApp());

    // Splash screen shows the app branding.
    expect(find.text('Society App'), findsOneWidget);
    expect(find.text('Smart Society Management'), findsOneWidget);

    // Let the splash auto-navigation timer fire, then settle on the picker.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('Choose your language'), findsOneWidget);
  });
}
