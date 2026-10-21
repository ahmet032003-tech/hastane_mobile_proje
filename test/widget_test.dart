import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/main.dart';

void main() {
  testWidgets('PatientLoginView renders and responds to input smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MedAutoApp());

    // Verify key UI elements exist
    expect(find.text('ACİL ŞİFA HASTANESİ'), findsOneWidget);
    expect(find.text('HASTA GİRİŞ PORTALI'), findsOneWidget);
    expect(find.text('T.C. Kimlik Numarası'), findsOneWidget);
    expect(find.text('Şifre'), findsOneWidget);
    expect(find.text('Giriş Yap'), findsOneWidget);
    expect(find.text('S.S.S.'), findsOneWidget);
  });
}
