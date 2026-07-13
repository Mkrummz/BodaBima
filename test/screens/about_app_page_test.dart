import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/about_app_page.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('AboutAppPage renders its title and action buttons',
      (tester) async {
    // AboutAppPage references Image.asset('images/boda.jpg'), which is not a
    // declared asset; wrapApp backs asset loads with a fake bundle so this
    // does not throw.
    await pumpApp(tester, const AboutAppPage());

    expect(find.text('About This Application'), findsOneWidget);
    expect(find.text('How to Become A Member'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Click Here to Access Form'), findsOneWidget);
    expect(find.text('Already A Member?'), findsOneWidget);
    expect(find.text('View Terms and Conditions'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
