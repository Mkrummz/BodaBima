import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_store.dart';
import '../theme/app_theme.dart';
import 'id_cards_page.dart';
import 'claims_page.dart';
import 'payments_page.dart';

class DashboardPage extends StatelessWidget {
  /// Switches the root bottom-nav tab (used by "View all" links).
  final void Function(int index) onSelectTab;
  const DashboardPage({super.key, required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(userName: store.userName, amountDue: store.amountDue, money: money),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _QuickActions(onSelectTab: onSelectTab),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      title: 'Your policies',
                      actionLabel: 'ID cards',
                      onAction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const IdCardsPage()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...store.policies.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PolicyCard(policy: p),
                        )),
                    const SizedBox(height: 12),
                    _SectionHeader(
                      title: 'Recent claims',
                      actionLabel: 'View all',
                      onAction: () => onSelectTab(1),
                    ),
                    const SizedBox(height: 10),
                    if (store.claims.isEmpty)
                      const Text('No claims yet.',
                          style: TextStyle(color: AppColors.textSecondary))
                    else
                      ...store.claims.take(2).map((c) => Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: const Icon(Icons.description_outlined,
                                  color: AppColors.navy),
                              title: Text('${c.type} · ${c.policyName}'),
                              subtitle: Text(
                                  'Filed ${DateFormat('MMM d').format(c.dateFiled)}'),
                            ),
                          )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String userName;
  final double amountDue;
  final NumberFormat money;
  const _Header(
      {required this.userName, required this.amountDue, required this.money});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 44),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navy, AppColors.navyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('BodaBima',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Icon(Icons.notifications_none, color: Colors.white),
              ],
            ),
            const SizedBox(height: 16),
            Text('Welcome back, $userName',
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              amountDue <= 0
                  ? "You're all paid up"
                  : '${money.format(amountDue)} due soon',
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final void Function(int index) onSelectTab;
  const _QuickActions({required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        Icons.badge_outlined,
        'ID Cards',
        () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const IdCardsPage())),
      ),
      (
        Icons.payments_outlined,
        'Make a\nPayment',
        () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PaymentsPage())),
      ),
      (
        Icons.car_crash_outlined,
        'Roadside\nHelp',
        () => _roadside(context),
      ),
      (
        Icons.note_add_outlined,
        'File a\nClaim',
        () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FileClaimPage())),
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions
              .map((a) => _ActionItem(icon: a.$1, label: a.$2, onTap: a.$3))
              .toList(),
        ),
      ),
    );
  }

  void _roadside(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Roadside assistance'),
        content: const Text(
            '24/7 help for breakdowns, towing and flat tyres.\n\nCall 0712 462 029?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final uri = Uri(scheme: 'tel', path: '0712462029');
              if (await canLaunchUrl(uri)) launchUrl(uri);
            },
            child: const Text('Call now'),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.navy, size: 24),
              ),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600, height: 1.15)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  const _SectionHeader(
      {required this.title, required this.actionLabel, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        TextButton(
          onPressed: onAction,
          child: Text(actionLabel,
              style: const TextStyle(
                  color: AppColors.navy, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final Policy policy;
  const _PolicyCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconForType(policy.type),
                  color: AppColors.navy, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(policy.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(policy.insuredItem,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text('#${policy.policyNumber}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(policy.monthlyPremium,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const Text('/mo',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ],
        ),
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
