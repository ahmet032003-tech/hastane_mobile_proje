import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/doctor_dashboard/widgets/tabs/doctor_e_prescription_tab.dart';
import 'package:hastane_otomasyon/features/medications/controllers/medications_controller.dart';
import 'package:hastane_otomasyon/features/medications/services/medication_repository.dart';
import 'package:hastane_otomasyon/features/medications/views/medications_view.dart';
import 'package:hastane_otomasyon/features/patient_auth/services/patient_auth_repository.dart';
import 'package:hastane_otomasyon/features/patient_home/models/patient_model.dart';
import 'package:hastane_otomasyon/features/patient_profile/views/patient_profile_view.dart';

void main() {
  setUp(() {
    MedicationRepository.instance.reset();
    PatientAuthRepository.instance.reset();
  });

  tearDown(() {
    MedicationRepository.instance.reset();
    PatientAuthRepository.instance.reset();
  });

  group('Doctor Prescription Assignment Unit Tests', () {
    test(
        'Doctor prescribes medication and it increases patient activeMedicationCount in repository',
        () {
      const tc = '12345678901';
      expect(MedicationRepository.instance.getActiveMedicationCount(tc), 3);

      final patientBefore = PatientAuthRepository.instance.getPatient(tc);
      expect(patientBefore?.activeMedicationCount, 3);

      // Doktor reçete ataması yapıyor
      final newMed = MedicationRepository.instance.prescribeMedication(
        patientTc: tc,
        patientName: 'Ayşe Yılmaz',
        medicineName: 'Atorvastatin 20 mg',
        dosage: '1x1 Gece Tok',
        usageInstructions: 'Günde 1 Defa (Tok Karnına)',
        doctorName: 'Doç. Dr. Emre Çetin',
        doctorBranch: 'Kardiyoloji Polikliniği 1',
      );

      expect(newMed.isActive, isTrue);
      expect(newMed.name, 'Atorvastatin 20 mg');
      expect(MedicationRepository.instance.getActiveMedicationCount(tc), 4);

      // Hasta profilindeki aktif ilaç sayısı 4 olarak senkronize olmalı
      final patientAfter = PatientAuthRepository.instance.getPatient(tc);
      expect(patientAfter?.activeMedicationCount, 4);
      expect(patientAfter?.lastDoctorName, 'Doç. Dr. Emre Çetin');
    });

    test('MedicationsController updates live when doctor assigns new medication',
        () {
      const tc = '12345678901';
      final controller = MedicationsController(patientTc: tc);
      expect(controller.value.activeCount, 3);

      // Doktor ataması
      MedicationRepository.instance.prescribeMedication(
        patientTc: tc,
        patientName: 'Ayşe Yılmaz',
        medicineName: 'Coraspin 100 mg',
        dosage: '1x1 Öğle Tok',
        usageInstructions: 'Günde 1 Defa (Tok Karnına)',
      );

      expect(controller.value.activeCount, 4);
      expect(
        controller.value.filteredMedications
            .any((m) => m.name == 'Coraspin 100 mg' && m.isActive),
        isTrue,
      );

      controller.dispose();
    });
  });

  group('Patient Profile & Medications Widget Tests', () {
    testWidgets(
        'PatientProfileView displays active medications and updates when doctor assigns medication',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final patient = PatientModel.mock();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: PatientProfileView(patient: patient),
        ),
      );
      await tester.pumpAndSettle();

      // Profil sayfasında Aktif Tedavi & İlaçlarım kartı ve ilk 3 aktif ilaç görünmeli
      expect(find.text('Aktif Tedavi & İlaçlarım'), findsOneWidget);
      expect(find.text('3 Aktif İlaç'), findsOneWidget);
      expect(find.text('Kopidogrel 75 mg Film Tablet'), findsOneWidget);
      expect(find.text('Ventolin İnhaler 100 mcg'), findsOneWidget);
      expect(find.text('Benexol B12 Kaplı Tablet'), findsOneWidget);

      // Doktor sisteme yeni ilaç atıyor
      MedicationRepository.instance.prescribeMedication(
        patientTc: patient.tc,
        patientName: patient.fullName,
        medicineName: 'Atorvastatin 20 mg',
        dosage: '1x1 Gece Tok',
        usageInstructions: 'Günde 1 Defa (Gece)',
        doctorName: 'Doç. Dr. Emre Çetin',
      );

      await tester.pumpAndSettle();

      // Profil sayfasında anında 4 Aktif İlaç ve yeni ilaç gözükmeli
      expect(find.text('4 Aktif İlaç'), findsOneWidget);
      expect(find.text('Atorvastatin 20 mg'), findsOneWidget);
    });

    testWidgets(
        'MedicationsView shows assigned medicine with active badge and increments active count',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const MedicationsView(patientTc: '12345678901'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3 Aktif İlaç'), findsOneWidget);

      // Doktor reçete atıyor
      MedicationRepository.instance.prescribeMedication(
        patientTc: '12345678901',
        patientName: 'Ayşe Yılmaz',
        medicineName: 'Augmentin 1000 mg',
        dosage: '2x1 Sabah/Akşam Tok',
        usageInstructions: 'Günde 2 Defa (Tok)',
      );

      await tester.pumpAndSettle();

      expect(find.text('4 Aktif İlaç'), findsOneWidget);
      expect(find.text('Augmentin 1000 mg'), findsOneWidget);
    });

    testWidgets(
        'DoctorEPrescriptionTab assigns medicines to patient profile on confirm',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: DoctorEPrescriptionTab(
              patientName: 'Ayşe Yılmaz',
              patientTc: '12345678901',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Butona tıklayıp reçeteyi hastaya ata
      await tester.tap(find.byKey(const ValueKey('confirm_prescription_button')));
      await tester.pumpAndSettle();

      // Bildirim ve başarı rozeti görünmeli
      expect(find.text('Profile Aktif Olarak İşlendi'), findsOneWidget);

      // Ayşe Yılmaz'ın aktif ilaç sayısı artmış olmalı
      final activeCount =
          MedicationRepository.instance.getActiveMedicationCount('12345678901');
      expect(activeCount, greaterThan(3));
    });
  });
}
