import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/claims_page.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('ClaimsPage lists the demo claims', (tester) async {
    await pumpApp(tester, const ClaimsPage());

    expect(find.text('Claims'), findsOneWidget);
    expect(find.text('File a claim'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.textContaining('Boda Comprehensive'), findsWidgets);
  });

  testWidgets('FileClaimPage renders the claim form', (tester) async {
    await pumpApp(tester, const FileClaimPage());

    expect(find.text('File a claim'), findsOneWidget);
    expect(find.text('Which policy?'), findsOneWidget);
    expect(find.text('Claim type'), findsOneWidget);
    expect(find.text('Submit claim'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });
}
