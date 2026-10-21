import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/features/doctor_auth/controllers/doctor_login_controller.dart';

void main() {
  group('DoctorLoginController Tests', () {
    late DoctorLoginController controller;

    setUp(() {
      controller = DoctorLoginController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state is correct', () {
      expect(controller.value.diplomaOrTc, isEmpty);
      expect(controller.value.institutionCode, isEmpty);
      expect(controller.value.password, isEmpty);
      expect(controller.value.isPasswordVisible, isFalse);
      expect(controller.value.isLoading, isFalse);
      expect(controller.value.isSuccess, isFalse);
      expect(controller.value.errorMessage, isNull);
    });

    test('Fields update and error clears when setting values', () {
      controller.setDiplomaOrTc(' 123456 ');
      expect(controller.value.diplomaOrTc, '123456');

      controller.setInstitutionCode(' ash-34 ');
      expect(controller.value.institutionCode, 'ASH-34');

      controller.setPassword('secret');
      expect(controller.value.password, 'secret');

      controller.togglePasswordVisibility();
      expect(controller.value.isPasswordVisible, isTrue);
    });

    test('Login validation fails with empty diploma/TC', () async {
      final success = await controller.login();
      expect(success, isFalse);
      expect(controller.value.errorMessage,
          contains('Diploma Tescil Numaranızı giriniz'));
    });

    test('Login validation fails with empty institution code', () async {
      controller.setDiplomaOrTc('123456');
      final success = await controller.login();
      expect(success, isFalse);
      expect(controller.value.errorMessage,
          contains('Kurum Kodunu giriniz'));
    });

    test('Login validation fails with empty password', () async {
      controller.setDiplomaOrTc('123456');
      controller.setInstitutionCode('ASH-34');
      final success = await controller.login();
      expect(success, isFalse);
      expect(controller.value.errorMessage, contains('şifrenizi giriniz'));
    });

    test('Login validation fails with invalid institution credentials', () async {
      controller.setDiplomaOrTc('999999');
      controller.setInstitutionCode('XYZ-99');
      controller.setPassword('wrongpassword');

      final success = await controller.login();
      expect(success, isFalse);
      expect(controller.value.errorMessage,
          contains('yetkili hekim kaydı bulunamadı'));
    });

    test('Login succeeds with valid demo doctor credentials', () async {
      controller.setDiplomaOrTc('123456');
      controller.setInstitutionCode('ASH-34');
      controller.setPassword('123456');

      final success = await controller.login();
      expect(success, isTrue);
      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.errorMessage, isNull);
    });
  });
}
