import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/doctor_dashboard/views/doctor_dashboard_view.dart';

void main() {
  testWidgets('DoctorDashboardView renders doctor header and operational metrics',
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
}
