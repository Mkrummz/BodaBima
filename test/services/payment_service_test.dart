import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:bima/services/payment_service.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockHttpClient httpClient;
  late MockSecureStorage storage;
  late PaymentService service;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    httpClient = MockHttpClient();
    storage = MockSecureStorage();
    service = PaymentService(client: httpClient, storage: storage);
    when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async {});
  });

  group('initiatePayment', () {
    test('returns success and stores the reference on a 200 response',
        () async {
      when(() => httpClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{"ok":true}', 200));

      final result = await service.initiatePayment(
        phoneNumber: '0712000000',
        amount: 500,
        provider: PaymentProvider.mpesa,
        reference: 'REF-1',
      );

      expect(result, {'success': true, 'reference': 'REF-1'});
      verify(() => storage.write(
          key: 'transaction_REF-1',
          value: any(named: 'value'))).called(1);
    });

    test('returns a failure map on a non-200 response', () async {
      when(() => httpClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('nope', 400));

      final result = await service.initiatePayment(
        phoneNumber: '0712000000',
        amount: 500,
        provider: PaymentProvider.tigoPesa,
        reference: 'REF-2',
      );

      expect(result['success'], isFalse);
      expect(result['error'], 'Payment initiation failed');
      verifyNever(() => storage.write(
          key: any(named: 'key'), value: any(named: 'value')));
    });

    test('returns a failure map when the request throws', () async {
      when(() => httpClient.post(any(), body: any(named: 'body')))
          .thenThrow(Exception('network down'));

      final result = await service.initiatePayment(
        phoneNumber: '0712000000',
        amount: 500,
        provider: PaymentProvider.airtelMoney,
        reference: 'REF-3',
      );

      expect(result['success'], isFalse);
      expect(result['error'], contains('network down'));
    });
  });

  group('checkPaymentStatus', () {
    test('returns the response body on success', () async {
      when(() => httpClient.get(any()))
          .thenAnswer((_) async => http.Response('COMPLETED', 200));

      final result = await service.checkPaymentStatus('REF-1');

      expect(result, {'success': true, 'status': 'COMPLETED'});
    });

    test('returns a failure map when the request throws', () async {
      when(() => httpClient.get(any())).thenThrow(Exception('timeout'));

      final result = await service.checkPaymentStatus('REF-1');

      expect(result['success'], isFalse);
      expect(result['error'], contains('timeout'));
    });
  });
}
