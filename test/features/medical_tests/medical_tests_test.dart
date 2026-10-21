import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/medical_tests/controllers/medical_tests_controller.dart';
import 'package:hastane_otomasyon/features/medical_tests/models/medical_test_model.dart';
import 'package:hastane_otomasyon/features/medical_tests/views/medical_tests_view.dart';

void main() {
  group('MedicalTestsController & State Tests', () {
    late MedicalTestsController controller;

    setUp(() {
      controller = MedicalTestsController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Default sort is descending (en yeni -> en eski)', () {
      expect(controller.value.isSortDescending, isTrue);
      final list = controller.value.filteredTests;

      // 14 Ekim 2026 Akciğer PA Grafisi en başta olmalı
      expect(list.first.testName, contains('Akciğer PA Grafisi'));
    });

    test('Filters by category (Radyoloji vs Laboratuvar)', () {
      controller.setCategory(TestCategory.radiology);
      final radiologyList = controller.value.filteredTests;

      expect(radiologyList.every((t) => t.isRadiology), isTrue);
      expect(radiologyList.length, 2);

      controller.setCategory(TestCategory.laboratory);
      final labList = controller.value.filteredTests;
      expect(labList.every((t) => !t.isRadiology), isTrue);
      expect(labList.length, 2);
    });

    test('Filters by search query', () {
      controller.setSearchQuery('EKO');
      final list = controller.value.filteredTests;

      expect(list.length, 1);
      expect(list.first.testName, contains('Ekokardiyografi'));
    });
  });

  group('MedicalTestsView Widget Tests', () {
    testWidgets('Renders test list and opens detail modal with reason and clinical comment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const MedicalTestsView(),
        ),
      );

      // Başlık ve sekmeler
      expect(find.text('Radyoloji & Tahliller'), findsOneWidget);
      expect(find.text('Tüm Tetkikler'), findsOneWidget);
      expect(find.text('Radyoloji'), findsWidgets);
      expect(find.text('Laboratuvar'), findsWidgets);

      // Kartlara tıkla (Radyoloji - Akciğer PA Grafisi)
      await tester.tap(find.text('Akciğer PA Grafisi (Röntgen)'));
      await tester.pumpAndSettle();

      // Detay modalında zorunlu alanlar görünmeli:
      // 1. İstemde bulunan hekim
      expect(find.text('İstemde Bulunan Hekim'), findsOneWidget);
      expect(find.text('Uzm. Dr. Selin Kaya'), findsWidgets);

      // 2. İstem gerekçesi ve amacı
      expect(find.text('İstem Gerekçesi ve Amacı'), findsOneWidget);
      expect(
        find.textContaining('parankimal ve plevral patolojilerin dışlanması'),
        findsOneWidget,
      );

      // 3. Test görseli (radyoloji)
      expect(find.text('Radyoloji Görüntüsü'), findsOneWidget);

      // 4. Uzman hekim açık klinik yorumu (aşağı kaydır)
      await tester.scrollUntilVisible(
        find.text('Uzman Hekim Açık Klinik Yorumu'),
        100,
        scrollable: find.byType(Scrollable).last,
      );

      expect(find.text('Uzman Hekim Açık Klinik Yorumu'), findsOneWidget);
      expect(
        find.textContaining('Kardiyotorasik indeks fizyolojik sınırlar'),
        findsOneWidget,
      );
    });
  });
}
