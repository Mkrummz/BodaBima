// Smoke test for the BodaBima app root.
//
// `main.dart`'s `MyApp` calls `Supabase.initialize` and injects
// `Supabase.instance.client` into `RootPage`. To avoid initializing Supabase
// (and its platform-channel session storage) in a unit-test environment, we
// pump `RootPage` directly with a mocked `SupabaseClient`, wrapped in the same
// localization configuration `MyApp` uses.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bima/main.dart';

import 'support/test_helpers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  testWidgets('RootPage renders the bottom navigation and dashboard',
      (WidgetTester tester) async {
    final localizations = await loadLocalizations();
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapApp(
          RootPage(
            changeLanguage: (_) {},
            selectedLocale: const Locale('en', 'US'),
            supabaseClient: MockSupabaseClient(),
          ),
          localizations,
        ),
      );
      await tester.pumpAndSettle();

      // Core scaffolding: the bottom navigation with all four destinations.
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Claims'), findsWidgets);
      expect(find.text('ID Cards'), findsWidgets);
      expect(find.text('More'), findsWidgets);

      // The default tab shows the dashboard branded header.
      expect(find.text('BodaBima'), findsOneWidget);
      expect(find.text('Your policies'), findsOneWidget);
    });
  });
}
