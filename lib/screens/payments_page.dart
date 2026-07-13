import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/app_store.dart';
import '../theme/app_theme.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _BalanceCard(
                amountDue: store.amountDue,
                money: money,
                onPay: () => _openPay(context, store, money),
              ),
              const SizedBox(height: 24),
              const Text('Payment history',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 8),
              ...store.payments.map((p) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFEAF1EA),
                        child: Icon(Icons.check, color: AppColors.accent),
                      ),
                      title: Text(p.description),
                      subtitle:
                          Text(DateFormat('MMM d, yyyy').format(p.date)),
                      trailing: Text(money.format(p.amount),
                          style:
                              const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  void _openPay(BuildContext context, AppStore store, NumberFormat money) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _PaySheet(store: store, money: money),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double amountDue;
  final NumberFormat money;
  final VoidCallback onPay;
  const _BalanceCard(
      {required this.amountDue, required this.money, required this.onPay});

  @override
  Widget build(BuildContext context) {
    final paidUp = amountDue <= 0;
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
          const Text('Current balance',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(money.format(amountDue),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
              ),
              onPressed: paidUp ? null : onPay,
              child: Text(paidUp ? 'You are all paid up' : 'Make a payment'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaySheet extends StatefulWidget {
  final AppStore store;
  final NumberFormat money;
  const _PaySheet({required this.store, required this.money});

  @override
  State<_PaySheet> createState() => _PaySheetState();
}

class _PaySheetState extends State<_PaySheet> {
  late double _amount = widget.store.amountDue;
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _done
            ? [
                const Icon(Icons.check_circle,
                    color: AppColors.accent, size: 56),
                const SizedBox(height: 12),
                Text('Payment of ${widget.money.format(_amount)} received',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('Thanks! Your balance has been updated.',
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Done'),
                  ),
                ),
              ]
            : [
                const Text('Make a payment',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                const Text('Amount',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _amount.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixText: 'KES ',
                  ),
                  onChanged: (v) =>
                      _amount = double.tryParse(v) ?? _amount,
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.credit_card, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text('Visa ****4242'),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      widget.store.makePayment(_amount);
                      setState(() => _done = true);
                    },
                    child: const Text('Pay now'),
                  ),
                ),
              ],
      ),
    );
  }
}
