import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/dashboard_page.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('DashboardPage renders the header, quick actions and policies',
      (tester) async {
    await pumpApp(tester, DashboardPage(onSelectTab: (_) {}));

    expect(find.text('BodaBima'), findsOneWidget);
    expect(find.textContaining('Welcome back'), findsOneWidget);
    expect(find.text('Your policies'), findsOneWidget);
    expect(find.text('Recent claims'), findsOneWidget);
    expect(find.text('ID Cards'), findsOneWidget);
    expect(find.text('Boda Comprehensive'), findsOneWidget);
  });
}
