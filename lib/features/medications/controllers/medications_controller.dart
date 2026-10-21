import 'package:flutter/foundation.dart';
import '../models/medication_model.dart';
import '../models/medications_state.dart';

/// İlaçlar ve Reçeteler modülü için ValueNotifier durum yöneticisi
class MedicationsController extends ValueNotifier<MedicationsState> {
  MedicationsController({List<MedicationModel>? initialMedications})
      : super(
          MedicationsState(
            medications: initialMedications ?? MedicationModel.mockList(),
          ),
        );

  /// Hastalık/Tanı bazlı filtre seçimi
  void setDiseaseFilter(String? disease) {
    if (value.selectedDiseaseFilter == disease) {
      // Zaten seçiliyse filtreyi kaldır
      value = value.copyWith(clearDiseaseFilter: true);
    } else {
      value = value.copyWith(selectedDiseaseFilter: disease);
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

  /// Detay kartı gösterilecek ilacı seç
  void selectMedication(MedicationModel? med) {
    value = value.copyWith(
      selectedMedication: med,
      clearSelectedMedication: med == null,
    );
  }

  /// Tüm filtreleri temizle
  void clearAllFilters() {
    value = value.copyWith(
      clearDiseaseFilter: true,
      searchQuery: '',
      isSortDescending: true,
    );
  }
}
