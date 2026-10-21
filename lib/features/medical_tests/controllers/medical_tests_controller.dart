import 'package:flutter/foundation.dart';
import '../models/medical_test_model.dart';
import '../models/medical_tests_state.dart';

/// Radyoloji ve Tahliller için ValueNotifier durum yöneticisi
class MedicalTestsController extends ValueNotifier<MedicalTestsState> {
  MedicalTestsController({List<MedicalTestModel>? initialTests})
      : super(
          MedicalTestsState(
            tests: initialTests ?? MedicalTestModel.mockList(),
          ),
        );

  /// Kategori seçimi (Tümü, Radyoloji, Laboratuvar)
  void setCategory(TestCategory? category) {
    if (value.selectedCategory == category) {
      value = value.copyWith(clearCategory: true);
    } else {
      value = value.copyWith(selectedCategory: category);
    }
  }

  /// Arama sorgusu güncelleme
  void setSearchQuery(String query) {
    value = value.copyWith(searchQuery: query);
  }

  /// Sıralama yönünü değiştir (En Yeni <-> En Eski)
  void toggleSortOrder() {
    value = value.copyWith(isSortDescending: !value.isSortDescending);
  }

  /// Detayı incelenecek tetkiki seç
  void selectTest(MedicalTestModel? test) {
    value = value.copyWith(
      selectedTest: test,
      clearSelectedTest: test == null,
    );
  }

  /// Tüm filtreleri temizle
  void clearAllFilters() {
    value = value.copyWith(
      clearCategory: true,
      searchQuery: '',
      isSortDescending: true,
    );
  }
}
