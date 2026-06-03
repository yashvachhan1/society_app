// Smoke tests: every feature screen must build and render its title without
// throwing. These give broad widget coverage for the SonarQube quality gate.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:society_app/features/alerts/screens/alerts_screen.dart';
import 'package:society_app/features/billing/screens/billing_screen.dart';
import 'package:society_app/features/complaints/screens/complaints_screen.dart';
import 'package:society_app/features/family/screens/family_screen.dart';
import 'package:society_app/features/guests/screens/guests_screen.dart';
import 'package:society_app/features/home/screens/home_screen.dart';
import 'package:society_app/features/notices/screens/notices_screen.dart';
import 'package:society_app/features/profile/screens/profile_screen.dart';
import 'package:society_app/features/staff/screens/staff_screen.dart';
import 'package:society_app/features/vehicles/screens/vehicles_screen.dart';

Future<void> _pump(WidgetTester tester, Widget screen) async {
  await tester.pumpWidget(MaterialApp(home: screen));
  await tester.pump();
}

void main() {
  testWidgets('HomeScreen renders dashboard', (tester) async {
    await _pump(tester, const HomeScreen());
    expect(find.text('Good Morning!'), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);
  });

  testWidgets('BillingScreen renders bill', (tester) async {
    await _pump(tester, const BillingScreen());
    expect(find.text('Billing & Payments'), findsOneWidget);
    expect(find.text('Bill Breakdown'), findsOneWidget);
  });

  testWidgets('NoticesScreen renders notices', (tester) async {
    await _pump(tester, const NoticesScreen());
    expect(find.text('Notice Board'), findsOneWidget);
  });

  testWidgets('ComplaintsScreen renders complaints', (tester) async {
    await _pump(tester, const ComplaintsScreen());
    expect(find.text('Complaints'), findsOneWidget);
  });

  testWidgets('GuestsScreen renders tabs', (tester) async {
    await _pump(tester, const GuestsScreen());
    expect(find.text('Guest Management'), findsOneWidget);
    expect(find.text('Guest Log'), findsOneWidget);
  });

  testWidgets('StaffScreen renders staff', (tester) async {
    await _pump(tester, const StaffScreen());
    expect(find.text('Domestic Staff'), findsOneWidget);
  });

  testWidgets('AlertsScreen renders alert grid', (tester) async {
    await _pump(tester, const AlertsScreen());
    expect(find.text('Quick Alerts'), findsOneWidget);
    expect(find.text('Tap to Send Alert'), findsOneWidget);
  });

  testWidgets('FamilyScreen renders members', (tester) async {
    await _pump(tester, const FamilyScreen());
    expect(find.text('Family Directory'), findsOneWidget);
  });

  testWidgets('VehiclesScreen renders vehicles', (tester) async {
    await _pump(tester, const VehiclesScreen());
    expect(find.text('Vehicle Registry'), findsOneWidget);
  });

  testWidgets('ProfileScreen renders profile', (tester) async {
    await _pump(tester, const ProfileScreen());
    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Rahul Sharma'), findsOneWidget);
  });
}
