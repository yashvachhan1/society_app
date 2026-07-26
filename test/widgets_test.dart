// Widget tests for the shared UI building blocks in core/widgets.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:society_app/core/theme/app_theme.dart';
import 'package:society_app/core/widgets/widgets.dart';

Future<void> _host(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(home: Scaffold(body: Center(child: child))),
  );
}

void main() {
  testWidgets('AppCard shows its child and responds to taps', (tester) async {
    var tapped = false;
    await _host(
      tester,
      AppCard(
        onTap: () => tapped = true,
        child: const Text('Card body'),
      ),
    );

    expect(find.text('Card body'), findsOneWidget);
    await tester.tap(find.text('Card body'));
    expect(tapped, isTrue);
  });

  testWidgets('SectionHeader fires its action', (tester) async {
    var seen = false;
    await _host(
      tester,
      SectionHeader(
        title: 'Recent',
        actionLabel: 'See all',
        onAction: () => seen = true,
      ),
    );

    expect(find.text('Recent'), findsOneWidget);
    await tester.tap(find.text('See all'));
    expect(seen, isTrue);
  });

  testWidgets('StatusChip.forStatus renders the label', (tester) async {
    await _host(tester, StatusChip.forStatus('Completed'));
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('IconChip renders icon and label', (tester) async {
    await _host(
      tester,
      const IconChip(
        label: 'Urgent',
        icon: Icons.warning_amber_rounded,
        color: AppColors.error,
      ),
    );
    expect(find.text('Urgent'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });

  testWidgets('InfoBanner renders its message', (tester) async {
    await _host(tester, const InfoBanner(message: 'Heads up!'));
    expect(find.text('Heads up!'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });

  testWidgets('EmptyState renders title and message', (tester) async {
    await _host(
      tester,
      const EmptyState(
        icon: Icons.inbox_outlined,
        title: 'Nothing here',
        message: 'Come back later',
      ),
    );
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Come back later'), findsOneWidget);
  });
}
