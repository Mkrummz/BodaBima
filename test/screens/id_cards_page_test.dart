import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/id_cards_page.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('IdCardsPage renders a digital ID card per policy',
      (tester) async {
    await pumpApp(tester, const IdCardsPage());

    expect(find.text('ID Cards'), findsOneWidget);
    expect(find.text('Your digital insurance ID cards'), findsOneWidget);
    expect(find.text('BodaBima Insurance'), findsWidgets);
    expect(find.textContaining('Insurance ID'), findsWidgets);
  });
}
