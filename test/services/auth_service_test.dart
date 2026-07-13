import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bima/services/auth_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

void main() {
  late MockSupabaseClient client;
  late MockGoTrueClient auth;
  late AuthService service;

  setUp(() {
    client = MockSupabaseClient();
    auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    service = AuthService(client: client);
  });

  group('registerUser', () {
    test('throws when the passwords do not match', () {
      expect(
        () => service.registerUser('a@b.com', 'pw1', 'pw2'),
        throwsA('Passwords do not match'),
      );
      verifyNever(() => auth.signUp(
          email: any(named: 'email'), password: any(named: 'password')));
    });

    test('completes when signUp returns a user', () async {
      when(() => auth.signUp(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => AuthResponse(user: MockUser()));

      await expectLater(
        service.registerUser('a@b.com', 'pw', 'pw'),
        completes,
      );
    });

    test('throws "Sign Up failed" when signUp returns no user', () async {
      when(() => auth.signUp(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => AuthResponse(user: null));

      await expectLater(
        service.registerUser('a@b.com', 'pw', 'pw'),
        throwsA('Sign Up failed'),
      );
    });

    test('rethrows errors from signUp', () async {
      when(() => auth.signUp(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const AuthException('boom'));

      await expectLater(
        service.registerUser('a@b.com', 'pw', 'pw'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('loginUser', () {
    test('completes when sign-in returns a user', () async {
      when(() => auth.signInWithPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => AuthResponse(user: MockUser()));

      await expectLater(
        service.loginUser('a@b.com', 'pw'),
        completes,
      );
    });

    test('rethrows errors from sign-in', () async {
      when(() => auth.signInWithPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const AuthException('invalid credentials'));

      await expectLater(
        service.loginUser('a@b.com', 'bad'),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
