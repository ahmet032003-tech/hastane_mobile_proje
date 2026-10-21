import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/patient_auth/views/patient_login_view.dart';
import 'package:hastane_otomasyon/features/patient_auth/views/patient_register_view.dart';

void main() {
  group('PatientRegisterView Widget Tests', () {
    testWidgets('Renders all registration fields and buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const PatientRegisterView(),
        ),
      );

      expect(find.text('Yeni Hasta Kaydı'), findsWidgets);
      expect(find.text('YENİ HASTA KAYIT FORMU'), findsOneWidget);
      expect(find.text('Kimlik Bilgileri'), findsOneWidget);
      expect(find.text('İletişim Bilgileri'), findsOneWidget);
      expect(find.text('Hesap Güvenliği'), findsOneWidget);

      expect(find.text('T.C. Kimlik Numarası *'), findsOneWidget);
      expect(find.text('Ad ve Soyad *'), findsOneWidget);
      expect(find.text('Doğum Tarihi *'), findsOneWidget);
      expect(find.text('Telefon Numarası *'), findsOneWidget);
      expect(find.text('Hasta Kaydını Tamamla'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('Tapping Kayıt Ol on PatientLoginView navigates to PatientRegisterView',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const PatientLoginView(),
        ),
      );

      // Verify on Login View
      expect(find.text('HASTA GİRİŞ PORTALI'), findsOneWidget);
      final registerLink = find.byKey(const ValueKey('patient_register_link'));
      expect(registerLink, findsOneWidget);

      // Scroll into view and tap 'Kayıt Ol'
      await tester.ensureVisible(registerLink);
      await tester.pumpAndSettle();
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      // Verify that PatientRegisterView is now displayed
      expect(find.text('YENİ HASTA KAYIT FORMU'), findsOneWidget);
      expect(find.text('Hasta Kaydını Tamamla'), findsOneWidget);

      // Tap Back button
      final backButton = find.byTooltip('Giriş Ekranına Dön');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify returned to PatientLoginView
      expect(find.text('HASTA GİRİŞ PORTALI'), findsOneWidget);
    });
  });
}
