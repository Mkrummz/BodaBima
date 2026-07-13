import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/app_store.dart';
import '../theme/app_theme.dart';

class IdCardsPage extends StatelessWidget {
  const IdCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('ID Cards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Your digital insurance ID cards',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Show these when requested. Tap a card to save it.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ...store.policies.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _IdCard(policy: p, userName: store.userName),
              )),
        ],
      ),
    );
  }
}

class _IdCard extends StatelessWidget {
  final Policy policy;
  final String userName;
  const _IdCard({required this.policy, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('BodaBima Insurance',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Icon(_iconForType(policy.type),
                  color: AppColors.accent, size: 26),
            ],
          ),
          const SizedBox(height: 2),
          Text('${policy.type} Insurance ID',
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 20),
          _row('Policyholder', userName),
          _row('Policy #', policy.policyNumber),
          _row('Insured', policy.insuredItem),
          _row('Valid through',
              DateFormat('MMM d, yyyy').format(policy.renewalDate)),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 12)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Motorcycle':
        return Icons.two_wheeler;
      case 'Health':
        return Icons.favorite;
      case 'Home':
        return Icons.home;
      default:
        return Icons.shield;
    }
  }
}
