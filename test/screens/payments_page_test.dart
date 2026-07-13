import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/payments_page.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('PaymentsPage renders the balance card and history',
      (tester) async {
    await pumpApp(tester, const PaymentsPage());

    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('Current balance'), findsOneWidget);
    expect(find.text('Payment history'), findsOneWidget);
  });
}
