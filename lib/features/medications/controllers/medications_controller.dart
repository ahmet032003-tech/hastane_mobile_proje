import 'package:flutter/foundation.dart';
import '../models/medication_model.dart';
import '../models/medications_state.dart';
import '../services/medication_repository.dart';

/// İlaçlar ve Reçeteler modülü için ValueNotifier durum yöneticisi
class MedicationsController extends ValueNotifier<MedicationsState> {
  final MedicationRepository _medicationRepository;
  final String? patientTc;
  bool _isDisposed = false;

  MedicationsController({
    List<MedicationModel>? initialMedications,
    MedicationRepository? medicationRepository,
    this.patientTc,
  })  : _medicationRepository =
            medicationRepository ?? MedicationRepository.instance,
        super(
          MedicationsState(
            medications: initialMedications ??
                (medicationRepository ?? MedicationRepository.instance)
                    .getMedicationsForPatient(patientTc),
          ),
        ) {
    if (initialMedications == null) {
      _medicationRepository.medicationsNotifier.addListener(_syncFromRepository);
    }
  }

  void _syncFromRepository() {
    if (_isDisposed) return;
    final updatedList = _medicationRepository.getMedicationsForPatient(patientTc);
    value = value.copyWith(medications: updatedList);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _medicationRepository.medicationsNotifier.removeListener(_syncFromRepository);
    super.dispose();
  }

  /// Aktif / Geçmiş durum filtresi seçimi (null = Tümü, true = Sadece Aktif, false = Sadece Geçmiş)
  void setStatusFilter(bool? activeFilter) {
    if (activeFilter == null || value.activeFilter == activeFilter) {
      value = value.copyWith(clearActiveFilter: true);
    } else {
      value = value.copyWith(activeFilter: activeFilter);
    }
  }

  /// Hastalık/Tanı bazlı filtre seçimi
  void setDiseaseFilter(String? disease) {
    if (disease == null || value.selectedDiseaseFilter == disease) {
      // Zaten seçiliyse veya null geldiyse filtreyi kaldır
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
      clearActiveFilter: true,
      searchQuery: '',
      isSortDescending: true,
    );
  }
}
