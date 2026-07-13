import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/emergency_assistance_page.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('EmergencyAssistancePage renders the emergency call card',
      (tester) async {
    final localizations = await loadLocalizations();

    await tester.pumpWidget(
      wrapApp(
        EmergencyAssistancePage(
          changeLanguage: (_) {},
          selectedLocale: const Locale('en', 'US'),
          localizations: localizations,
        ),
        localizations,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Emergency Services'), findsOneWidget);
    expect(find.text('Call Emergency Services'), findsOneWidget);
    expect(find.byIcon(Icons.emergency), findsOneWidget);

    // Quick action grid and safety tips.
    expect(find.text('Call Local Police'), findsOneWidget);
    expect(find.text('Safety Tips'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });
}
