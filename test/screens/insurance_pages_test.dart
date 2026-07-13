import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bima/screens/medical_insurance_page.dart';
import 'package:bima/screens/motor_insurance_page.dart';
import 'package:bima/screens/home_insurance_page.dart';
import 'package:bima/screens/travel_insurance_page.dart';

import '../support/test_helpers.dart';

void main() {
  testWidgets('MedicalInsurancePage renders its title', (tester) async {
    await pumpApp(tester, const MedicalInsurancePage());
    expect(find.text('Medical Insurance'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('MotorInsurancePage renders its title', (tester) async {
    await pumpApp(tester, const MotorInsurancePage());
    expect(find.text('Motor Insurance'), findsOneWidget);
  });

  testWidgets('HomeInsurancePage renders its title', (tester) async {
    await pumpApp(tester, const HomeInsurancePage());
    expect(find.text('Home Insurance'), findsOneWidget);
  });

  testWidgets('TravelInsurancePage renders its title', (tester) async {
    await pumpApp(tester, const TravelInsurancePage());
    expect(find.text('Travel Insurance'), findsOneWidget);
  });
}
