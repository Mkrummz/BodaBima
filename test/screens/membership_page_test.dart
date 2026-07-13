import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/membership_page.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('MembershipPage renders the support contacts', (tester) async {
    final localizations = await loadLocalizations();

    await tester.pumpWidget(
      wrapApp(
        MembershipPage(
          changeLanguage: (_) {},
          selectedLocale: const Locale('en', 'US'),
          localizations: localizations,
        ),
        localizations,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('24/7 Emergency Support'), findsOneWidget);
    expect(find.text('Motor Claims'), findsOneWidget);
    expect(find.text('General Inquiries'), findsOneWidget);
    expect(find.text('Business Hours'), findsOneWidget);
    expect(find.byIcon(Icons.phone), findsWidgets);
  });
}
