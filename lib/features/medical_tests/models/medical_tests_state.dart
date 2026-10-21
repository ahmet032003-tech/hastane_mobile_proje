import 'package:flutter/foundation.dart';
import 'medical_test_model.dart';

/// Radyoloji ve Tahliller Durum Modeli (Immutable)
@immutable
class MedicalTestsState {
  final List<MedicalTestModel> tests;
  final TestCategory? selectedCategory;
  final String searchQuery;

  /// Varsayılan: true = En yeni -> en eski, false = En eski -> en yeni
  final bool isSortDescending;
  final MedicalTestModel? selectedTest;

  const MedicalTestsState({
    this.tests = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.isSortDescending = true, // SKILL.md: Varsayılan en yeni -> en eski
    this.selectedTest,
  });

  /// Filtrelenmiş ve sıralanmış tetkik listesi
  List<MedicalTestModel> get filteredTests {
    final query = searchQuery.trim().toLowerCase();

    final result = tests.where((test) {
      // 1. Arama Sorgusu
      final matchesQuery = query.isEmpty ||
          test.testName.toLowerCase().contains(query) ||
          test.requestingDoctor.toLowerCase().contains(query) ||
          test.requestReason.toLowerCase().contains(query);

      // 2. Kategori Filtresi (Radyoloji / Laboratuvar)
      final matchesCategory =
          selectedCategory == null || test.category == selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();

    // 3. Tarih Sıralaması
    result.sort((a, b) {
      return isSortDescending
          ? b.testDate.compareTo(a.testDate)
          : a.testDate.compareTo(b.testDate);
    });

    return result;
  }

  MedicalTestsState copyWith({
    List<MedicalTestModel>? tests,
    TestCategory? selectedCategory,
    String? searchQuery,
    bool? isSortDescending,
    MedicalTestModel? selectedTest,
    bool clearCategory = false,
    bool clearSelectedTest = false,
  }) {
    return MedicalTestsState(
      tests: tests ?? this.tests,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      isSortDescending: isSortDescending ?? this.isSortDescending,
      selectedTest: clearSelectedTest
          ? null
          : (selectedTest ?? this.selectedTest),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalTestsState &&
        listEquals(other.tests, tests) &&
        other.selectedCategory == selectedCategory &&
        other.searchQuery == searchQuery &&
        other.isSortDescending == isSortDescending &&
        other.selectedTest == selectedTest;
  }

  @override
  int get hashCode {
    return tests.hashCode ^
        selectedCategory.hashCode ^
        searchQuery.hashCode ^
        isSortDescending.hashCode ^
        selectedTest.hashCode;
  }
}
