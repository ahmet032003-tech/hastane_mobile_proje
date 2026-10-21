import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/patient_auth/services/patient_auth_repository.dart';
import 'package:hastane_otomasyon/features/patient_home/models/patient_model.dart';
import 'package:hastane_otomasyon/features/patient_home/widgets/patient_health_metrics.dart';
import 'package:hastane_otomasyon/features/patient_profile/views/patient_profile_view.dart';

void main() {
  group('PatientAuthRepository Password & Metrics Tests', () {
    late PatientAuthRepository repository;

    setUp(() {
      repository = PatientAuthRepository.instance;
      repository.reset();
    });

    tearDown(() {
      repository.reset();
    });

    test('verifyPassword validates current password', () {
      expect(repository.verifyPassword('12345678901', '123456'), isTrue);
      expect(repository.verifyPassword('12345678901', 'wrong_pass'), isFalse);
      expect(repository.verifyPassword('99999999999', '123456'), isFalse);
    });

    test('updatePassword changes password when current password is correct', () {
      final success = repository.updatePassword('12345678901', '123456', 'new_secret_123');
      expect(success, isTrue);

      // Verify old password no longer works
      expect(repository.authenticate('12345678901', '123456'), isNull);

      // Verify new password works
      expect(repository.authenticate('12345678901', 'new_secret_123'), isNotNull);
    });

    test('updatePassword fails when current password is wrong', () {
      final success = repository.updatePassword('12345678901', 'wrong_password', 'new_secret_123');
      expect(success, isFalse);

      // Old password remains valid
      expect(repository.authenticate('12345678901', '123456'), isNotNull);
    });

    test('updatePatientData persists updated height and weight', () {
      final initial = repository.getPatient('12345678901')!;
      expect(initial.heightCm, 168.0);
      expect(initial.weightKg, 62.5);

      final updated = initial.copyWith(heightCm: 175.0, weightKg: 70.0);
      repository.updatePatientData(updated);

      final fetched = repository.getPatient('12345678901')!;
      expect(fetched.heightCm, 175.0);
      expect(fetched.weightKg, 70.0);
      expect(fetched.bmi, 22.9);
    });
  });

  group('PatientHealthMetrics Manual Height & Weight Editing Widget Tests', () {
    testWidgets('Opens edit modal when tapping Düzenle button and updates values',
        (WidgetTester tester) async {
      PatientModel currentPatient = PatientModel.mock();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return PatientHealthMetrics(
                  patient: currentPatient,
                  onPatientUpdated: (updated) {
                    setState(() {
                      currentPatient = updated;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify initial values
      expect(find.text('168 cm'), findsOneWidget);
      expect(find.text('62.5 kg'), findsOneWidget);

      // Find and tap "Düzenle" button
      final editButton = find.byKey(const ValueKey('edit_health_metrics_button'));
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Verify bottom sheet opened
      expect(find.text('Boy ve Kilo Güncelle'), findsOneWidget);
      expect(find.text('Değerleri Kaydet'), findsOneWidget);

      // Change height and weight
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.at(0), '180');
      await tester.enterText(textFields.at(1), '75');
      await tester.pumpAndSettle();

      // Tap Save
      final saveButton = find.byKey(const ValueKey('save_health_metrics_button'));
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify values updated in the widget
      expect(find.text('180 cm'), findsOneWidget);
      expect(find.text('75.0 kg'), findsOneWidget);
    });

    testWidgets('Tapping Boy card directly opens edit modal', (WidgetTester tester) async {
      final patient = PatientModel.mock();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: PatientHealthMetrics(patient: patient),
          ),
        ),
      );

      // Tap on Boy card
      await tester.tap(find.text('Boy'));
      await tester.pumpAndSettle();

      expect(find.text('Boy ve Kilo Güncelle'), findsOneWidget);
    });

    testWidgets('Tapping Kilo card directly opens edit modal', (WidgetTester tester) async {
      final patient = PatientModel.mock();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: PatientHealthMetrics(patient: patient),
          ),
        ),
      );

      // Tap on Kilo card
      await tester.tap(find.text('Kilo'));
      await tester.pumpAndSettle();

      expect(find.text('Boy ve Kilo Güncelle'), findsOneWidget);
    });
  });

  group('PatientProfileView Password Change Widget Tests', () {
    setUp(() {
      PatientAuthRepository.instance.reset();
    });

    tearDown(() {
      PatientAuthRepository.instance.reset();
    });

    testWidgets('Opens Change Password modal, validates current password, and updates new password',
        (WidgetTester tester) async {
      final patient = PatientModel.mock(); // TC: 12345678901, default password: '123456'

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: PatientProfileView(patient: patient),
        ),
      );

      // Scroll to change password tile
      final changePasswordTile = find.byKey(const ValueKey('change_password_tile'));
      expect(changePasswordTile, findsOneWidget);
      await tester.ensureVisible(changePasswordTile);
      await tester.pumpAndSettle();

      // Tap Şifre Değiştir
      await tester.tap(changePasswordTile);
      await tester.pumpAndSettle();

      // Verify modal opened
      expect(find.text('Mevcut Şifre *'), findsOneWidget);
      expect(find.text('Yeni Şifre *'), findsOneWidget);
      expect(find.text('Yeni Şifre Tekrarı *'), findsOneWidget);
      expect(find.text('Şifreyi Güncelle'), findsOneWidget);

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(3));

      // 1. Try with wrong current password
      await tester.enterText(textFields.at(0), 'wrong_pass');
      await tester.enterText(textFields.at(1), 'newPassword123');
      await tester.enterText(textFields.at(2), 'newPassword123');
      await tester.pumpAndSettle();

      final submitButton = find.byKey(const ValueKey('submit_change_password_button'));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.textContaining('Mevcut şifreniz hatalı'), findsOneWidget);

      // 2. Try with matching current password, but mismatched new passwords
      await tester.enterText(textFields.at(0), '123456');
      await tester.enterText(textFields.at(1), 'newPassword123');
      await tester.enterText(textFields.at(2), 'mismatchedPass');
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Yeni şifreler birbiriyle eşleşmiyor'), findsOneWidget);

      // 3. Try with correct current password and valid matching new password
      await tester.enterText(textFields.at(0), '123456');
      await tester.enterText(textFields.at(1), 'newPassword123');
      await tester.enterText(textFields.at(2), 'newPassword123');
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      // Wait for delay and animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Verify modal dismissed and SnackBar shown
      expect(find.textContaining('şifreniz başarıyla değiştirildi'), findsOneWidget);

      // Verify password was updated in repository
      expect(PatientAuthRepository.instance.authenticate('12345678901', 'newPassword123'), isNotNull);
      expect(PatientAuthRepository.instance.authenticate('12345678901', '123456'), isNull);
    });
  });
}
