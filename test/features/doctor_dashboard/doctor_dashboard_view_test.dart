import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/doctor_dashboard/views/doctor_dashboard_view.dart';

void main() {
  testWidgets(
      'DoctorDashboardView renders doctor header and operational metrics',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const DoctorDashboardView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Doç. Dr. Emre Çetin'), findsOneWidget);
    expect(find.text('Kardiyoloji Polikliniği 1'), findsOneWidget);
    expect(find.text('Poliklinik Muayenesi: AÇIK'), findsOneWidget);
    expect(find.text('Toplam Randevu'), findsOneWidget);
    expect(find.text('Tamamlanan'), findsOneWidget);
    expect(find.text('Bekleyen Hasta'), findsOneWidget);
    expect(find.text('Fatma Şahin'), findsWidgets);
    expect(find.text('Muayeneyi Başlat'), findsOneWidget);
  });

  testWidgets(
      'DoctorDashboardView examination flow calls next patient after Hasan Yurtseven and informs doctor when queue is empty',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const DoctorDashboardView(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Fatma Şahin muayenesini başlat ve tamamla
    await tester.tap(find.text('Muayeneyi Başlat'));
    await tester.pumpAndSettle();
    expect(find.text('Muayeneyi Tamamla & Sıradakini Çağır'), findsOneWidget);

    await tester.tap(find.text('Muayeneyi Tamamla & Sıradakini Çağır'));
    await tester.pumpAndSettle();

    // Hasan Yurtseven çağrılmış olmalı
    expect(find.text('Hasan Yurtseven'), findsWidgets);
    expect(find.text('Muayeneyi Başlat'), findsOneWidget);

    // 2. Hasan Yurtseven muayenesini başlat ve tamamla
    await tester.tap(find.text('Muayeneyi Başlat'));
    await tester.pumpAndSettle();
    expect(find.text('Muayeneyi Tamamla & Sıradakini Çağır'), findsOneWidget);

    await tester.tap(find.text('Muayeneyi Tamamla & Sıradakini Çağır'));
    await tester.pumpAndSettle();

    // Sıradaki hasta (Zeynep Kaya) çağrılmış olmalı!
    expect(find.text('Zeynep Kaya'), findsWidgets);
    expect(find.text('Muayeneyi Başlat'), findsOneWidget);

    // 3. Zeynep Kaya muayenesini başlat ve tamamla
    await tester.tap(find.text('Muayeneyi Başlat'));
    await tester.pumpAndSettle();
    expect(find.text('Muayeneyi Tamamla & Sıradakini Çağır'), findsOneWidget);

    await tester.tap(find.text('Muayeneyi Tamamla & Sıradakini Çağır'));
    await tester.pumpAndSettle();

    // Tüm hastalar bittiğinde doktora bilgilendirme diyaloğu açılmış olmalı
    expect(find.text('Tüm Muayeneler Tamamlandı'), findsWidgets);
    expect(
        find.text(
            'Sayın hekimimiz, bugünkü poliklinik randevu listesindeki tüm hastaların muayenesi başarıyla tamamlandı.\n\nBekleyen başka hasta kalmamıştır. Tebrik eder, iyi dinlenmeler dileriz.'),
        findsOneWidget);

    // Diyaloğu kapat
    await tester.tap(find.text('Anladım'));
    await tester.pumpAndSettle();

    // Ekranda tüm muayenelerin tamamlandığına dair kart gösterilmeli
    expect(find.text('Bekleyen Hasta: 0 • Poliklinik Tamamlandı'), findsOneWidget);
    expect(find.text('Sırayı Yeniden Başlat (Demo)'), findsOneWidget);
  });
}
