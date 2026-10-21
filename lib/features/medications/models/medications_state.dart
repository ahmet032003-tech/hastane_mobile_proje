import 'package:flutter/foundation.dart';
import 'medication_model.dart';

/// İlaçlar ve Reçeteler Durum Modeli (Immutable)
@immutable
class MedicationsState {
  final List<MedicationModel> medications;
  final String? selectedDiseaseFilter;
  final String searchQuery;

  /// Varsayılan sıralama: true = en yakından/en yeniden en eskiye, false = en uzaktan/en eskiden en yeniye
  final bool isSortDescending;
  final MedicationModel? selectedMedication;

  const MedicationsState({
    this.medications = const [],
    this.selectedDiseaseFilter,
    this.searchQuery = '',
    this.isSortDescending = true, // SKILL.md: Varsayılan olarak en yeni -> en eski
    this.selectedMedication,
  });

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

      return matchesQuery && matchesDisease;
    }).toList();

    // 3. Sıralama: En yeni -> en eski veya tam tersi
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
    bool? isSortDescending,
    MedicationModel? selectedMedication,
    bool clearDiseaseFilter = false,
    bool clearSelectedMedication = false,
  }) {
    return MedicationsState(
      medications: medications ?? this.medications,
      selectedDiseaseFilter: clearDiseaseFilter
          ? null
          : (selectedDiseaseFilter ?? this.selectedDiseaseFilter),
      searchQuery: searchQuery ?? this.searchQuery,
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
        other.isSortDescending == isSortDescending &&
        other.selectedMedication == selectedMedication;
  }

  @override
  int get hashCode {
    return medications.hashCode ^
        selectedDiseaseFilter.hashCode ^
        searchQuery.hashCode ^
        isSortDescending.hashCode ^
        selectedMedication.hashCode;
  }
}
