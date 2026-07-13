import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/localizations.dart';
import '../theme/app_theme.dart';
import 'emergency_assistance_page.dart';
import 'membership_page.dart';
import 'profile_page.dart';
import 'medical_insurance_page.dart';
import 'motor_insurance_page.dart';
import 'home_insurance_page.dart';
import 'travel_insurance_page.dart';
import 'payments_page.dart';

class MorePage extends StatelessWidget {
  final void Function(Locale) changeLanguage;
  final Locale selectedLocale;
  final SupabaseClient supabaseClient;
  const MorePage({
    super.key,
    required this.changeLanguage,
    required this.selectedLocale,
    required this.supabaseClient,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = selectedLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(20),
                isSelected: [lang == 'en', lang == 'sw'],
                onPressed: (i) =>
                    changeLanguage(Locale(i == 0 ? 'en' : 'sw')),
                selectedColor: AppColors.navy,
                fillColor: Colors.white,
                color: Colors.white,
                constraints:
                    const BoxConstraints(minHeight: 32, minWidth: 44),
                children: const [Text('ENG'), Text('SW')],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _tile(context, Icons.payments_outlined, 'Payments',
              const PaymentsPage()),
          _tile(
            context,
            Icons.emergency_outlined,
            l.translate('emergency_assistance') ?? 'Emergency Assistance',
            EmergencyAssistancePage(
              changeLanguage: changeLanguage,
              selectedLocale: selectedLocale,
              localizations: l,
            ),
          ),
          _tile(
            context,
            Icons.support_agent,
            'Call Us',
            MembershipPage(
              changeLanguage: changeLanguage,
              selectedLocale: selectedLocale,
              localizations: l,
            ),
          ),
          _tile(
            context,
            Icons.person_outline,
            l.translate('profile') ?? 'Profile',
            ProfilePage(
              changeLanguage: changeLanguage,
              selectedLocale: selectedLocale,
              localizations: l,
              supabaseClient: supabaseClient,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Learn about coverage',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary)),
          ),
          _tile(context, Icons.favorite_border,
              l.translate('medical_insurance') ?? 'Medical Insurance',
              const MedicalInsurancePage()),
          _tile(context, Icons.two_wheeler,
              l.translate('motor_insurance') ?? 'Motor Insurance',
              const MotorInsurancePage()),
          _tile(context, Icons.home_outlined,
              l.translate('home_insurance') ?? 'Home Insurance',
              const HomeInsurancePage()),
          _tile(context, Icons.flight_takeoff,
              l.translate('travel_insurance') ?? 'Travel Insurance',
              const TravelInsurancePage()),
        ],
      ),
    );
  }

  Widget _tile(
      BuildContext context, IconData icon, String label, Widget page) {
    return ListTile(
      leading: Icon(icon, color: AppColors.navy),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => page)),
    );
  }
}
