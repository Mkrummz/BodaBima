import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/educational_center.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('EducationCenter renders the collapsed lesson tiles',
      (tester) async {
    await pumpApp(tester, const EducationCenter());

    // Default (English) locale title.
    expect(find.text('Education Center'), findsOneWidget);
    // Both lessons render as (collapsed) expansion tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));
    expect(find.text('What is Insurance?'), findsOneWidget);
    expect(find.text('Types of Insurance'), findsOneWidget);
  });
}
