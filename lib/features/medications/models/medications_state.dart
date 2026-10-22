import 'package:flutter/foundation.dart';
import 'medication_model.dart';

/// İlaçlar ve Reçeteler Durum Modeli (Immutable)
@immutable
class MedicationsState {
  final List<MedicationModel> medications;
  final String? selectedDiseaseFilter;
  final String searchQuery;

  /// null: Tümü, true: Sadece Aktif İlaçlar, false: Sadece Geçmiş İlaçlar
  final bool? activeFilter;

  /// Varsayılan sıralama: true = en yakından/en yeniden en eskiye, false = en uzaktan/en eskiden en yeniye
  final bool isSortDescending;
  final MedicationModel? selectedMedication;

  const MedicationsState({
    this.medications = const [],
    this.selectedDiseaseFilter,
    this.searchQuery = '',
    this.activeFilter,
    this.isSortDescending = true, // SKILL.md: Varsayılan olarak en yeni -> en eski
    this.selectedMedication,
  });

  /// Aktif (güncel) ilaç sayısı
  int get activeCount => medications.where((m) => m.isActive).length;

  /// Geçmiş (tamamlanan) ilaç sayısı
  int get pastCount => medications.where((m) => !m.isActive).length;

  /// Filtrelenmiş ve sıralanmış ilaç listesi
  List<MedicationModel> get filteredMedications {
    final query = searchQuery.trim().toLowerCase();

    final result = medications.where((med) {
      // 1. Arama Filtresi
      final matchesQuery = query.isEmpty ||
          med.name.toLowerCase().contains(query) ||
          med.doctorName.toLowerCase().contains(query) ||
          med.diseaseReason.toLowerCase().contains(query);

      // 2. Hastalık / Tanı Filtresi
      final matchesDisease = selectedDiseaseFilter == null ||
          med.diseaseReason == selectedDiseaseFilter;

      // 3. Aktif / Geçmiş Durum Filtresi
      final matchesStatus =
          activeFilter == null || med.isActive == activeFilter;

      return matchesQuery && matchesDisease && matchesStatus;
    }).toList();

    // 4. Sıralama: En yeni -> en eski veya tam tersi
    result.sort((a, b) {
      return isSortDescending
          ? b.prescribedDate.compareTo(a.prescribedDate)
          : a.prescribedDate.compareTo(b.prescribedDate);
    });

    return result;
  }

  /// Mevcut ilaçlardan çıkarılan tekil hastalık/tanı listesi
  List<String> get availableDiseases {
    return medications.map((m) => m.diseaseReason).toSet().toList();
  }

  MedicationsState copyWith({
    List<MedicationModel>? medications,
    String? selectedDiseaseFilter,
    String? searchQuery,
    bool? activeFilter,
    bool? isSortDescending,
    MedicationModel? selectedMedication,
    bool clearDiseaseFilter = false,
    bool clearActiveFilter = false,
    bool clearSelectedMedication = false,
  }) {
    return MedicationsState(
      medications: medications ?? this.medications,
      selectedDiseaseFilter: clearDiseaseFilter
          ? null
          : (selectedDiseaseFilter ?? this.selectedDiseaseFilter),
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter:
          clearActiveFilter ? null : (activeFilter ?? this.activeFilter),
      isSortDescending: isSortDescending ?? this.isSortDescending,
      selectedMedication: clearSelectedMedication
          ? null
          : (selectedMedication ?? this.selectedMedication),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicationsState &&
        listEquals(other.medications, medications) &&
        other.selectedDiseaseFilter == selectedDiseaseFilter &&
        other.searchQuery == searchQuery &&
        other.activeFilter == activeFilter &&
        other.isSortDescending == isSortDescending &&
        other.selectedMedication == selectedMedication;
  }

  @override
  int get hashCode {
    return medications.hashCode ^
        selectedDiseaseFilter.hashCode ^
        searchQuery.hashCode ^
        activeFilter.hashCode ^
        isSortDescending.hashCode ^
        selectedMedication.hashCode;
  }
}
