import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/features/patient_auth/controllers/patient_login_controller.dart';
import 'package:hastane_otomasyon/features/patient_auth/models/patient_login_state.dart';

void main() {
  group('PatientLoginController Tests', () {
    late PatientLoginController controller;

    setUp(() {
      controller = PatientLoginController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state is correct', () {
      expect(controller.value.tc, isEmpty);
      expect(controller.value.password, isEmpty);
      expect(controller.value.isPasswordVisible, isFalse);
      expect(controller.value.status, PatientLoginStatus.initial);
      expect(controller.value.errorMessage, isNull);
      expect(controller.value.shouldRedirectToRegister, isFalse);
    });

    test('setTc filters non-digits and limits to 11 chars', () {
      controller.setTc('123abc456!7890123');
      expect(controller.value.tc, '12345678901');
      expect(controller.value.tc.length, 11);
    });

    test('togglePasswordVisibility flips isPasswordVisible', () {
      expect(controller.value.isPasswordVisible, isFalse);
      controller.togglePasswordVisibility();
      expect(controller.value.isPasswordVisible, isTrue);
      controller.togglePasswordVisibility();
      expect(controller.value.isPasswordVisible, isFalse);
    });

    test('login with empty TC sets failure without redirection', () async {
      final success = await controller.login();
      expect(success, isFalse);
      expect(controller.value.status, PatientLoginStatus.failure);
      expect(controller.value.errorMessage, contains('T.C. Kimlik Numaranızı'));
      expect(controller.value.shouldRedirectToRegister, isFalse);
    });

    test('login with invalid TC length sets failure and redirect flag', () async {
      controller.setTc('12345');
      controller.setPassword('123456');

      final success = await controller.login();
      expect(success, isFalse);
      expect(controller.value.status, PatientLoginStatus.failure);
      expect(controller.value.shouldRedirectToRegister, isTrue);
    });

    test('login with invalid algorithmic TC sets failure and redirect flag', () async {
      controller.setTc('99999999999');
      controller.setPassword('123456');

      final success = await controller.login();
      expect(success, isFalse);
      expect(controller.value.status, PatientLoginStatus.failure);
      expect(controller.value.shouldRedirectToRegister, isTrue);
      expect(controller.value.errorMessage, contains('Geçersiz T.C. Kimlik Numarası'));
    });

    test('login with valid format but unregistered TC sets failure and redirect flag', () async {
      // 10000000146 is a mathematically valid TC, but unregistered
      controller.setTc('10000000146');
      controller.setPassword('123456');

      final success = await controller.login();
      expect(success, isFalse);
      expect(controller.value.status, PatientLoginStatus.failure);
      expect(controller.value.shouldRedirectToRegister, isTrue);
      expect(controller.value.errorMessage, contains('kayıtlı bir hasta hesabı bulunamadı'));
    });

    test('login with valid registered demo credentials succeeds', () async {
      controller.setTc('12345678901');
      controller.setPassword('123456');

      final success = await controller.login();
      expect(success, isTrue);
      expect(controller.value.status, PatientLoginStatus.success);
      expect(controller.value.errorMessage, isNull);
      expect(controller.value.shouldRedirectToRegister, isFalse);
    });
  });
}
