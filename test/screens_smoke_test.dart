// Smoke tests: every screen must build and render its key content without
// throwing, and the registration wizard must walk end to end.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_app/features/auth/screens/language_screen.dart';
import 'package:society_app/features/common/screens/empty_module_screen.dart';
import 'package:society_app/features/home/screens/home_screen.dart';
import 'package:society_app/features/profile/screens/profile_screen.dart';
import 'package:society_app/features/registration/screens/pending_approval_screen.dart';
import 'package:society_app/features/registration/screens/registration_screen.dart';

Future<void> _pump(WidgetTester tester, Widget screen) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await tester.pumpWidget(MaterialApp(home: screen));
  await tester.pump();
}

void main() {
  testWidgets('LanguageScreen offers all three languages', (tester) async {
    await _pump(tester, const LanguageScreen());
    expect(find.text('Choose your language'), findsOneWidget);
    // "English" is both the native and the English label, so it appears twice.
    expect(find.text('English'), findsWidgets);
    expect(find.text('हिंदी'), findsOneWidget);
    expect(find.text('मराठी'), findsOneWidget);
  });

  testWidgets('HomeScreen shows the greeting and the module grid', (
    tester,
  ) async {
    await _pump(tester, const HomeScreen());
    expect(find.text('Good Morning!'), findsOneWidget);
    expect(find.text('Flat 301 • Owner'), findsOneWidget);
    // "Services" is both the section heading and a module tile.
    expect(find.text('Services'), findsWidgets);
    expect(find.text('Complaints'), findsOneWidget);
    expect(find.text('Recent Notices'), findsOneWidget);
  });

  testWidgets('EmptyModuleScreen explains that a module is not built', (
    tester,
  ) async {
    await _pump(
      tester,
      const EmptyModuleScreen(title: 'Notices', icon: Icons.campaign),
    );
    expect(find.text('Notices'), findsOneWidget);
    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  testWidgets('ProfileScreen shows every account and membership field', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pump(tester, const ProfileScreen());
    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Rahul Sharma'), findsWidgets);
    expect(find.text('Account Details'), findsOneWidget);
    // users columns
    expect(find.text('+91 98765 43210'), findsOneWidget);
    expect(find.text('rahul.sharma@email.com'), findsOneWidget);
    expect(find.text('Last login'), findsOneWidget);
    // memberships columns
    expect(find.text('Membership'), findsOneWidget);
    expect(find.text('Member since'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('PendingApprovalScreen explains the approval steps', (
    tester,
  ) async {
    await _pump(tester, const PendingApprovalScreen());
    expect(find.text('Waiting for approval'), findsOneWidget);
    expect(find.text('Request submitted'), findsOneWidget);
    expect(find.text('Admin review'), findsOneWidget);
  });

  testWidgets('registration wizard walks from phone to proof', (tester) async {
    tester.view.physicalSize = const Size(420, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pump(tester, const RegistrationScreen());

    // Step 1 — phone + OTP. Continue stays disabled until the OTP is entered.
    expect(find.text('Verify your phone'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '9876543210');
    await tester.pump();
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 2 — name is required.
    expect(find.text('About you'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Rahul Sharma');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 3 — pick a society.
    expect(find.text('Find your society'), findsOneWidget);
    await tester.tap(find.text('Sunrise Residency'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 4 — pick a flat.
    expect(find.text('Your flat'), findsOneWidget);
    await tester.tap(find.text('Flat 402'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 5 — proof upload unlocks the submit button.
    expect(find.text('Upload proof'), findsOneWidget);
    expect(find.text('Submit for approval'), findsOneWidget);
    await tester.tap(find.text('Tap to upload'));
    await tester.pumpAndSettle();
    expect(find.text('Ready to submit'), findsOneWidget);
  });

  testWidgets('a tenant is asked for their rent agreement dates', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pump(tester, const RegistrationScreen());

    // Walk to the flat step.
    await tester.enterText(find.byType(TextField).first, '9876543210');
    await tester.pump();
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Priya Mehta');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sunrise Residency'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flat 402'));
    await tester.pumpAndSettle();

    // As an owner there are no agreement fields.
    expect(find.text('Agreement start'), findsNothing);

    // Switching to Tenant reveals them — unit_occupancies.agreement_start/end.
    await tester.tap(find.text('Tenant'));
    await tester.pumpAndSettle();
    expect(find.text('Agreement start'), findsOneWidget);
    expect(find.text('Agreement end'), findsOneWidget);
  });
}
