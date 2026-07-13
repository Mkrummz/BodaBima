import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bima/screens/home_page.dart';

import '../support/test_helpers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  testWidgets(
      'Homepage falls back to demo data and renders the insurance carousel',
      (tester) async {
    // The mocked client is not stubbed, so `fetchInsurancePlans` fails and the
    // widget falls back to bundled demo data (its designed offline behavior).
    final localizations = await loadLocalizations();
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapApp(
          Homepage(
            supabaseClient: MockSupabaseClient(),
            changeLanguage: (_) {},
            selectedLocale: const Locale('en', 'US'),
          ),
          localizations,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(ListView), findsWidgets);
      expect(find.byType(Image), findsWidgets);
      expect(find.text('Protect What Matters Most'), findsOneWidget);

      // Dispose the tree to cancel the carousel's autoplay timer.
      await tester.pumpWidget(const SizedBox());
    });
  });
}
