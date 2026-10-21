import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/medications/controllers/medications_controller.dart';
import 'package:hastane_otomasyon/features/medications/views/medications_view.dart';

void main() {
  group('MedicationsController & State Tests', () {
    late MedicationsController controller;

    setUp(() {
      controller = MedicationsController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Default sort is descending (en yeni -> en eski)', () {
      expect(controller.value.isSortDescending, isTrue);
      final list = controller.value.filteredMedications;

      // En yeni tarihli ilaç en başta olmalı (12 Ekim 2026 Kopidogrel)
      expect(list.first.name, contains('Kopidogrel'));
      // En eski tarihli ilaç en sonda olmalı (10 Nisan 2026 Muscoflex)
      expect(list.last.name, contains('Muscoflex'));
    });

    test('toggleSortOrder changes sort to ascending (en eski -> en yeni)', () {
      controller.toggleSortOrder();
      expect(controller.value.isSortDescending, isFalse);

      final list = controller.value.filteredMedications;
      // En eski tarihli ilaç en başta olmalı
      expect(list.first.name, contains('Muscoflex'));
      // En yeni tarihli ilaç en sonda olmalı
      expect(list.last.name, contains('Kopidogrel'));
    });

    test('Filters by disease reason', () {
      controller.setDiseaseFilter('Alerjik Astım');
      final list = controller.value.filteredMedications;

      expect(list.length, 1);
      expect(list.first.name, contains('Ventolin'));
      expect(list.first.diseaseReason, 'Alerjik Astım');

      // Aynı filtre tekrar seçilince kalkmalı
      controller.setDiseaseFilter('Alerjik Astım');
      expect(controller.value.selectedDiseaseFilter, isNull);
      expect(controller.value.filteredMedications.length, greaterThan(1));
    });

    test('Filters by search query', () {
      controller.setSearchQuery('B12');
      final list = controller.value.filteredMedications;

      expect(list.length, 1);
      expect(list.first.name, contains('Benexol'));
    });
  });

  group('MedicationsView Widget Tests', () {
    testWidgets('Renders medication cards and opens detail modal on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const MedicationsView(),
        ),
      );

      // Başlık ve filtreler
      expect(find.text('İlaçlar ve Reçeteler'), findsOneWidget);
      expect(find.text('En Yeni'), findsOneWidget);
      expect(find.text('Tümü'), findsOneWidget);

      // İlaç kartları görünmeli
      expect(find.text('Kopidogrel 75 mg Film Tablet'), findsOneWidget);
      expect(find.text('Ventolin İnhaler 100 mcg'), findsOneWidget);

      // İlaç kartına tıkla ve detay modalını aç
      await tester.tap(find.text('Kopidogrel 75 mg Film Tablet'));
      await tester.pumpAndSettle();

      // Detay modalında zorunlu alanlar görünmeli (hekim, gerekçe, son kullanım, kullanım talimatı)
      expect(find.text('İlacı Yazan Hekim'), findsOneWidget);
      expect(find.text('Doç. Dr. Emre Çetin'), findsOneWidget);
      expect(find.text('Yazılma Gerekçesi (Hastalık / Tanı)'), findsOneWidget);
      expect(find.text('Esansiyel Hipertansiyon'), findsWidgets);
      expect(find.text('Son Kullanım Tarihi'), findsOneWidget);
      expect(find.text('10.11.2027'), findsOneWidget);
      expect(find.text('Kullanım Talimatı (Aç/Tok & Dozaj)'), findsOneWidget);
      expect(find.text('Günde 1 Defa (Tok Karnına)'), findsWidgets);
    });
  });
}
