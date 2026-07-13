import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/localizations.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_page.dart';
import 'screens/claims_page.dart';
import 'screens/id_cards_page.dart';
import 'screens/more_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xfihpvkbzppaejluyqoq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmaWhwdmtienBwYWVqbHV5cW9xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg1NDQzMzgsImV4cCI6MjA0NDEyMDMzOH0.U30_ovXdjGrovUZhBeVbeXtX-Xg29BPNZF9mhz7USfM',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _selectedLanguageLocale = const Locale('en', 'US');

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _selectedLanguageLocale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('sw', 'TZ'),
      ],
      locale: _selectedLanguageLocale,
      home: RootPage(
        changeLanguage: _changeLanguage,
        selectedLocale: _selectedLanguageLocale,
        supabaseClient: Supabase.instance.client,
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;
  final Locale selectedLocale;
  final SupabaseClient supabaseClient;

  const RootPage({
    super.key,
    required this.changeLanguage,
    required this.selectedLocale,
    required this.supabaseClient,
  });

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;

  void _selectTab(int index) => setState(() => currentPage = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(onSelectTab: _selectTab),
      const ClaimsPage(),
      const IdCardsPage(),
      MorePage(
        changeLanguage: widget.changeLanguage,
        selectedLocale: widget.selectedLocale,
        supabaseClient: widget.supabaseClient,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: currentPage, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPage,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.description_outlined),
              selectedIcon: Icon(Icons.description),
              label: 'Claims'),
          NavigationDestination(
              icon: Icon(Icons.badge_outlined),
              selectedIcon: Icon(Icons.badge),
              label: 'ID Cards'),
          NavigationDestination(
              icon: Icon(Icons.menu),
              selectedIcon: Icon(Icons.menu),
              label: 'More'),
        ],
      ),
    );
  }
}
