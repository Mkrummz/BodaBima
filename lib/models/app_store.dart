import 'package:flutter/foundation.dart';

/// An insurance policy held by the demo user.
class Policy {
  final String id;
  final String type; // e.g. Auto, Motorcycle, Home, Health
  final String name;
  final String policyNumber;
  final String insuredItem; // e.g. "2021 Toyota Vitz" or "Home - Nairobi"
  final String coverageAmount;
  final String monthlyPremium;
  final DateTime renewalDate;

  const Policy({
    required this.id,
    required this.type,
    required this.name,
    required this.policyNumber,
    required this.insuredItem,
    required this.coverageAmount,
    required this.monthlyPremium,
    required this.renewalDate,
  });
}

enum ClaimStatus { submitted, inReview, approved, paid }

class Claim {
  final String id;
  final String policyId;
  final String policyName;
  final String type;
  final String description;
  final DateTime dateFiled;
  ClaimStatus status;

  Claim({
    required this.id,
    required this.policyId,
    required this.policyName,
    required this.type,
    required this.description,
    required this.dateFiled,
    this.status = ClaimStatus.submitted,
  });
}

class PaymentRecord {
  final String id;
  final String description;
  final double amount;
  final DateTime date;

  const PaymentRecord({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
  });
}

/// Simple in-memory store so demo actions (filing a claim, making a payment)
/// actually mutate state and reflect across the UI. No backend required.
class AppStore extends ChangeNotifier {
  AppStore._();
  static final AppStore instance = AppStore._();

  final String userName = 'Alex';

  final List<Policy> policies = [
    Policy(
      id: 'p1',
      type: 'Motorcycle',
      name: 'Boda Comprehensive',
      policyNumber: 'BB-MC-4471902',
      insuredItem: '2022 Boxer 150 · KDL 221X',
      coverageAmount: 'KES 250,000',
      monthlyPremium: 'KES 900',
      renewalDate: DateTime(2026, 12, 1),
    ),
    Policy(
      id: 'p2',
      type: 'Health',
      name: 'Boda Health Plus',
      policyNumber: 'BB-HL-8830145',
      insuredItem: 'Rider + 1 dependant',
      coverageAmount: 'KES 1,000,000',
      monthlyPremium: 'KES 1,200',
      renewalDate: DateTime(2026, 9, 15),
    ),
    Policy(
      id: 'p3',
      type: 'Home',
      name: 'Home Shield',
      policyNumber: 'BB-HM-5562098',
      insuredItem: 'Home · Nairobi, Kasarani',
      coverageAmount: 'KES 1,500,000',
      monthlyPremium: 'KES 600',
      renewalDate: DateTime(2027, 1, 20),
    ),
  ];

  final List<Claim> claims = [
    Claim(
      id: 'c1',
      policyId: 'p1',
      policyName: 'Boda Comprehensive',
      type: 'Accident',
      description: 'Minor collision at Thika Rd roundabout, bent front rim.',
      dateFiled: DateTime(2026, 6, 28),
      status: ClaimStatus.inReview,
    ),
    Claim(
      id: 'c2',
      policyId: 'p2',
      policyName: 'Boda Health Plus',
      type: 'Outpatient',
      description: 'Clinic visit and prescription reimbursement.',
      dateFiled: DateTime(2026, 5, 10),
      status: ClaimStatus.paid,
    ),
  ];

  final List<PaymentRecord> payments = [
    PaymentRecord(
      id: 'pay1',
      description: 'June premium · all policies',
      amount: 2700,
      date: DateTime(2026, 6, 1),
    ),
    PaymentRecord(
      id: 'pay2',
      description: 'May premium · all policies',
      amount: 2700,
      date: DateTime(2026, 5, 1),
    ),
  ];

  /// Total monthly premium across policies, in KES.
  double get monthlyTotal => 900 + 1200 + 600;

  /// Amount currently due.
  double amountDue = 2700;

  int _seq = 100;

  void fileClaim({
    required Policy policy,
    required String type,
    required String description,
  }) {
    _seq++;
    claims.insert(
      0,
      Claim(
        id: 'c$_seq',
        policyId: policy.id,
        policyName: policy.name,
        type: type,
        description: description,
        dateFiled: DateTime.now(),
        status: ClaimStatus.submitted,
      ),
    );
    notifyListeners();
  }

  void makePayment(double amount) {
    _seq++;
    payments.insert(
      0,
      PaymentRecord(
        id: 'pay$_seq',
        description: 'Payment · Visa ****4242',
        amount: amount,
        date: DateTime.now(),
      ),
    );
    amountDue = (amountDue - amount).clamp(0, double.infinity);
    notifyListeners();
  }
}
