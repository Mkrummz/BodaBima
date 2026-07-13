import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bima/l10n/localizations.dart';

/// A 1x1 transparent PNG used to satisfy any `Image.asset` load in tests,
/// including assets that are referenced by the app but not declared in
/// `pubspec.yaml` (e.g. `images/boda.jpg`).
final Uint8List kTransparentPng = Uint8List.fromList(const <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// Asset bundle that returns a valid tiny PNG for every binary asset load so
/// widget tests never fail on missing/undeclared image assets, while still
/// delegating string loads (e.g. the `.arb` localization files) to the real
/// [rootBundle].
class FakeAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    try {
      // Declared assets (and internal keys like AssetManifest.bin) load for
      // real from the root bundle.
      return await rootBundle.load(key);
    } catch (_) {
      // Undeclared image assets fall back to a valid tiny PNG so widget tests
      // do not fail on missing images.
      return ByteData.view(kTransparentPng.buffer);
    }
  }
}

const List<Locale> kSupportedLocales = <Locale>[
  Locale('en', 'US'),
  Locale('sw', 'TZ'),
];

/// A localizations delegate that returns an already-loaded [AppLocalizations]
/// synchronously. The app's real [AppLocalizations.delegate] loads `.arb`
/// files from the bundle asynchronously, which does not resolve reliably under
/// `pumpAndSettle`; preloading the value and serving it via a
/// [SynchronousFuture] makes widget trees resolve on the first frame.
class PreloadedAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const PreloadedAppLocalizationsDelegate(this.value);

  final AppLocalizations value;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture(value);

  @override
  bool shouldReload(PreloadedAppLocalizationsDelegate old) => false;
}

/// Wraps [child] in a [MaterialApp] configured with the same supported locales
/// as `lib/main.dart` and a preloaded [AppLocalizations] so that
/// `AppLocalizations.of(context)` resolves synchronously during tests. Image
/// asset loads are backed by [FakeAssetBundle].
Widget wrapApp(
  Widget child,
  AppLocalizations localizations, {
  Locale locale = const Locale('en', 'US'),
}) {
  return DefaultAssetBundle(
    bundle: FakeAssetBundle(),
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        PreloadedAppLocalizationsDelegate(localizations),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: kSupportedLocales,
      home: child,
    ),
  );
}

final Map<String, AppLocalizations> _localizationsCache =
    <String, AppLocalizations>{};

/// Builds a fully loaded [AppLocalizations] for [locale] for screens whose
/// constructors require a `localizations` argument. Results are cached per
/// language code because loading `.arb` assets more than once from the real
/// [rootBundle] within a single test file does not resolve reliably.
Future<AppLocalizations> loadLocalizations(
    [Locale locale = const Locale('en', 'US')]) async {
  final cached = _localizationsCache[locale.languageCode];
  if (cached != null) {
    return cached;
  }
  final localizations = await AppLocalizations.delegate.load(locale);
  _localizationsCache[locale.languageCode] = localizations;
  return localizations;
}

/// Preloads localizations, pumps [child] wrapped in the app scaffolding, and
/// (by default) settles. Returns the loaded [AppLocalizations] in case the
/// test needs it.
Future<AppLocalizations> pumpApp(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('en', 'US'),
  bool settle = true,
}) async {
  final localizations = await loadLocalizations(locale);
  await tester.pumpWidget(wrapApp(child, localizations, locale: locale));
  if (settle) {
    await tester.pumpAndSettle();
  }
  return localizations;
}
