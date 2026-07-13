import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bima/screens/profile_page.dart';

import '../support/test_helpers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  testWidgets('ProfilePage renders the login form', (tester) async {
    final localizations = await loadLocalizations();

    await tester.pumpWidget(
      wrapApp(
        ProfilePage(
          changeLanguage: (_) {},
          selectedLocale: const Locale('en', 'US'),
          localizations: localizations,
          supabaseClient: MockSupabaseClient(),
        ),
        localizations,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up Instead'), findsOneWidget);
    expect(find.byIcon(Icons.language), findsOneWidget);
  });
}
