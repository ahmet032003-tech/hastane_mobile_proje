import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/features/patient_auth/controllers/patient_register_controller.dart';
import 'package:hastane_otomasyon/features/patient_auth/models/patient_register_state.dart';
import 'package:hastane_otomasyon/features/patient_auth/services/patient_auth_repository.dart';

void main() {
  group('PatientRegisterController Tests', () {
    late PatientAuthRepository repository;
    late PatientRegisterController controller;

    setUp(() {
      repository = PatientAuthRepository.instance;
      repository.reset();
      controller = PatientRegisterController(authRepository: repository);
    });

    tearDown(() {
      controller.dispose();
      repository.reset();
    });

    test('Initial state is correct', () {
      expect(controller.value.tc, isEmpty);
      expect(controller.value.fullName, isEmpty);
      expect(controller.value.phone, isEmpty);
      expect(controller.value.email, isEmpty);
      expect(controller.value.birthDate, isEmpty);
      expect(controller.value.gender, 'Kadın');
      expect(controller.value.bloodType, 'A Rh(+)');
      expect(controller.value.isKvkkAccepted, isFalse);
      expect(controller.value.status, PatientRegisterStatus.initial);
      expect(controller.value.errorMessage, isNull);
    });

    test('setTc filters non-digits and limits to 11 chars', () {
      controller.setTc('123abc456!7890123');
      expect(controller.value.tc, '12345678901');
      expect(controller.value.tc.length, 11);
    });

    test('togglePasswordVisibility flips states', () {
      expect(controller.value.isPasswordVisible, isFalse);
      controller.togglePasswordVisibility();
      expect(controller.value.isPasswordVisible, isTrue);

      expect(controller.value.isPasswordConfirmVisible, isFalse);
      controller.togglePasswordConfirmVisibility();
      expect(controller.value.isPasswordConfirmVisible, isTrue);
    });

    test('register fails when TC is empty', () async {
      final success = await controller.register();
      expect(success, isFalse);
      expect(controller.value.status, PatientRegisterStatus.failure);
      expect(controller.value.errorMessage, contains('T.C. Kimlik Numaranızı'));
    });

    test('register fails when TC is invalid algorithmic number', () async {
      controller.setTc('99999999999');
      final success = await controller.register();
      expect(success, isFalse);
      expect(controller.value.status, PatientRegisterStatus.failure);
      expect(controller.value.errorMessage, contains('Geçersiz T.C. Kimlik Numarası'));
    });

    test('register fails when TC is already registered in repository', () async {
      controller.setTc('12345678901'); // Already in default repository
      controller.setFullName('Ayşe Yılmaz');
      controller.setPhone('05321234567');
      controller.setBirthDate('01.01.1990');
      controller.setPassword('123456');
      controller.setPasswordConfirm('123456');
      controller.setKvkkAccepted(true);

      final success = await controller.register();
      expect(success, isFalse);
      expect(controller.value.status, PatientRegisterStatus.failure);
      expect(controller.value.errorMessage, contains('zaten kayıtlı'));
    });

    test('register fails when Full Name is too short', () async {
      // 10000000146 is a valid mathematical TC
      controller.setTc('10000000146');
      controller.setFullName('A');

      final success = await controller.register();
      expect(success, isFalse);
      expect(controller.value.errorMessage, contains('adınızı ve soyadınızı'));
    });

    test('register fails when Phone is too short', () async {
      controller.setTc('10000000146');
      controller.setFullName('Kemal Aydın');
      controller.setPhone('123');

      final success = await controller.register();
      expect(success, isFalse);
      expect(controller.value.errorMessage, contains('telefon numarası'));
    });

    test('register fails when Passwords do not match', () async {
      controller.setTc('10000000146');
      controller.setFullName('Kemal Aydın');
      controller.setPhone('05321112233');
      controller.setBirthDate('10.05.1992');
      controller.setPassword('123456');
      controller.setPasswordConfirm('654321');
      controller.setKvkkAccepted(true);

      final success = await controller.register();
      expect(success, isFalse);
      expect(controller.value.errorMessage, contains('şifreler birbiriyle eşleşmiyor'));
    });

    test('register fails when KVKK is not accepted', () async {
      controller.setTc('10000000146');
      controller.setFullName('Kemal Aydın');
      controller.setPhone('05321112233');
      controller.setBirthDate('10.05.1992');
      controller.setPassword('123456');
      controller.setPasswordConfirm('123456');
      controller.setKvkkAccepted(false);

      final success = await controller.register();
      expect(success, isFalse);
      expect(controller.value.errorMessage, contains('KVKK'));
    });

    test('register succeeds with valid details and saves to repository', () async {
      controller.setTc('10000000146');
      controller.setFullName('Kemal Aydın');
      controller.setPhone('05321112233');
      controller.setEmail('kemal.aydin@gmail.com');
      controller.setBirthDate('10.05.1992');
      controller.setGender('Erkek');
      controller.setBloodType('0 Rh(+)');
      controller.setPassword('kemal123');
      controller.setPasswordConfirm('kemal123');
      controller.setKvkkAccepted(true);

      final success = await controller.register();
      expect(success, isTrue);
      expect(controller.value.status, PatientRegisterStatus.success);
      expect(controller.value.errorMessage, isNull);
      expect(controller.value.registeredPatient, isNotNull);
      expect(controller.value.registeredPatient!.fullName, 'Kemal Aydın');
      expect(controller.value.registeredPatient!.tc, '10000000146');

      // Verify it can now authenticate in repository
      final authenticated = repository.authenticate('10000000146', 'kemal123');
      expect(authenticated, isNotNull);
      expect(authenticated!.fullName, 'Kemal Aydın');
    });
  });
}
