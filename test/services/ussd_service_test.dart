import 'package:flutter_test/flutter_test.dart';
import 'package:bima/services/ussd_service.dart';

void main() {
  group('UssdService.generateUssdCode', () {
    test('uses the USSD prefix and the mapped code for every known action', () {
      for (final entry in UssdService.ussdCodes.entries) {
        final code = UssdService.generateUssdCode(entry.key);
        expect(code, '${UssdService.USSD_PREFIX}*${entry.value}');
      }
    });

    test('produces the documented format for a known action', () {
      expect(UssdService.generateUssdCode('checkBalance'), '*150*00#*1');
      expect(UssdService.generateUssdCode('viewPlans'), '*150*00#*2');
      expect(UssdService.generateUssdCode('makePayment'), '*150*00#*3');
      expect(UssdService.generateUssdCode('emergency'), '*150*00#*4');
      expect(UssdService.generateUssdCode('support'), '*150*00#*5');
    });

    test('appends every param value in insertion order', () {
      final code = UssdService.generateUssdCode(
        'makePayment',
        params: {'amount': '500', 'ref': 'ABC'},
      );
      expect(code, '*150*00#*3*500*ABC');
    });

    test('ignores param keys and appends only values', () {
      final code = UssdService.generateUssdCode(
        'checkBalance',
        params: {'pin': '1234'},
      );
      expect(code, '*150*00#*1*1234');
    });

    test('an empty params map behaves like no params', () {
      expect(
        UssdService.generateUssdCode('support', params: {}),
        UssdService.generateUssdCode('support'),
      );
    });

    test('unknown actions render a null code segment', () {
      expect(UssdService.generateUssdCode('nope'), '*150*00#*null');
    });
  });
}
