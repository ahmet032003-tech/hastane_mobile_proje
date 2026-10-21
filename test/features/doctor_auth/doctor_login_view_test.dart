import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/doctor_auth/views/doctor_login_view.dart';

void main() {
  testWidgets('DoctorLoginView renders title, cross logo, and input fields',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const DoctorLoginView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ACİL ŞİFA HASTANESİ'), findsOneWidget);
    expect(find.text('HEKİM & DOKTOR PORTALI'), findsOneWidget);
    expect(find.text('T.C. / Diploma Tescil No'), findsOneWidget);
    expect(find.text('Kurum Kodu'), findsOneWidget);
    expect(find.text('Hekim Şifresi'), findsOneWidget);
    expect(find.text('Doktor Girişi Yap'), findsOneWidget);
    expect(find.text('Hasta Portalı Girişi İçin Tıklayınız ➔'), findsOneWidget);
  });
}
