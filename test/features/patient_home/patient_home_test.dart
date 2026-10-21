import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/patient_home/controllers/patient_home_controller.dart';
import 'package:hastane_otomasyon/features/patient_home/models/patient_model.dart';
import 'package:hastane_otomasyon/features/patient_home/views/patient_home_view.dart';
import 'package:hastane_otomasyon/features/patient_profile/views/patient_profile_view.dart';

void main() {
  group('PatientModel Tests', () {
    test('Calculates BMI and categories correctly', () {
      final patient = PatientModel.mock();
      expect(patient.heightCm, 168.0);
      expect(patient.weightKg, 62.5);
      expect(patient.bmi, 22.1);
      expect(patient.bmiCategory, 'Normal / İdeal');
    });
  });

  group('PatientHomeController Tests', () {
    test('Switches tabs within 0-3 range', () {
      final controller = PatientHomeController();
      expect(controller.value.selectedTabIndex, 0);

      controller.setTabIndex(1);
      expect(controller.value.selectedTabIndex, 1);

      controller.setTabIndex(3);
      expect(controller.value.selectedTabIndex, 3);

      // Out of range should be ignored
      controller.setTabIndex(9);
      expect(controller.value.selectedTabIndex, 3);

      controller.dispose();
    });

    test('Toggles disease filter', () {
      final controller = PatientHomeController();
      expect(controller.value.selectedDiseaseFilter, isNull);

      controller.toggleDiseaseFilter('Alerjik Astım');
      expect(controller.value.selectedDiseaseFilter, 'Alerjik Astım');

      controller.toggleDiseaseFilter('Alerjik Astım');
      expect(controller.value.selectedDiseaseFilter, isNull);

      controller.dispose();
    });
  });

  group('PatientHomeView & PatientProfileView UI Tests', () {
    testWidgets('PatientHomeView renders header, metrics, chips, and 4-tab bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const PatientHomeView(),
        ),
      );

      // 1. Üst Bölüm: Hasta profil adı, son ziyaret tarihi, son hekim ve branş
      expect(find.text('Ayşe Yılmaz'), findsOneWidget);
      expect(find.text('Son Hastane Ziyareti'), findsOneWidget);
      expect(find.text('12 Ekim 2026'), findsOneWidget);
      expect(find.text('Doç. Dr. Emre Çetin'), findsOneWidget);
      expect(find.text('Kardiyoloji Polikliniği'), findsOneWidget);

      // 2. Kişisel Sağlık Verileri: Boy, Kilo, BMI, Aktif İlaç
      expect(find.text('168 cm'), findsOneWidget);
      expect(find.text('62.5 kg'), findsOneWidget);
      expect(find.text('22.1'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // 3. Aktif Hastalıklar chipleri
      expect(find.text('Esansiyel Hipertansiyon'), findsOneWidget);
      expect(find.text('Alerjik Astım'), findsOneWidget);

      // 4. Alt Navigasyon Barı (4 sekme)
      expect(find.text('Randevu Al'), findsWidgets);
      expect(find.text('İlaç/Reçete'), findsOneWidget);
      expect(find.text('Radyoloji/Tahlil'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);

      // Sekme değiştirme testi: Profil sekmesine tıkla (Index 3)
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();

      // Profil sayfasının detayları görünmeli
      expect(find.text('Hasta Profili'), findsOneWidget);
      expect(find.text('T.C. 12345678901'), findsOneWidget);
      expect(find.text('Doğum Tarihi'), findsOneWidget);
      expect(find.text('14 Mayıs 1988'), findsOneWidget);
      expect(find.text('A Rh(+)'), findsOneWidget);
      expect(find.text('+90 (532) 555 12 34'), findsOneWidget);
      expect(find.text('Oturumu Kapat'), findsOneWidget);
    });

    testWidgets('PatientProfileView directly displays all personal info rows',
        (WidgetTester tester) async {
      final mockPatient = PatientModel.mock();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: PatientProfileView(patient: mockPatient),
        ),
      );

      expect(find.text('Hasta Profili'), findsOneWidget);
      expect(find.text('Ayşe Yılmaz'), findsOneWidget);
      expect(find.text('T.C. 12345678901'), findsOneWidget);
      expect(find.text('Doğum Tarihi'), findsOneWidget);
      expect(find.text('Cinsiyet'), findsOneWidget);
      expect(find.text('Kan Grubu'), findsOneWidget);
      expect(find.text('Telefon Numarası'), findsOneWidget);
      expect(find.text('E-Posta Adresi'), findsOneWidget);
      expect(find.text('İkametgah Adresi'), findsOneWidget);
      expect(find.text('ayse.yilmaz@medauto.health'), findsOneWidget);
    });
  });
}
