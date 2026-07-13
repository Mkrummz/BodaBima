import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bima/screens/more_page.dart';

import '../support/test_helpers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  testWidgets('MorePage renders the menu and language toggle', (tester) async {
    await pumpApp(
      tester,
      MorePage(
        changeLanguage: (_) {},
        selectedLocale: const Locale('en', 'US'),
        supabaseClient: MockSupabaseClient(),
      ),
    );

    expect(find.text('More'), findsOneWidget);
    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('Emergency Assistance'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byType(ToggleButtons), findsOneWidget);
    expect(find.text('ENG'), findsOneWidget);
    expect(find.text('SW'), findsOneWidget);
  });
}
