import 'package:flutter/foundation.dart';
import 'patient_model.dart';

/// Hasta ana sayfası ve alt menü sekmeleri durum modeli
@immutable
class PatientHomeState {
  final PatientModel patient;
  final int selectedTabIndex;
  final bool isLoading;
  final String? selectedDiseaseFilter;

  const PatientHomeState({
    required this.patient,
    this.selectedTabIndex = 0,
    this.isLoading = false,
    this.selectedDiseaseFilter,
  });

  PatientHomeState copyWith({
    PatientModel? patient,
    int? selectedTabIndex,
    bool? isLoading,
    String? selectedDiseaseFilter,
    bool clearFilter = false,
  }) {
    return PatientHomeState(
      patient: patient ?? this.patient,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
      selectedDiseaseFilter: clearFilter
          ? null
          : (selectedDiseaseFilter ?? this.selectedDiseaseFilter),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientHomeState &&
        other.patient == patient &&
        other.selectedTabIndex == selectedTabIndex &&
        other.isLoading == isLoading &&
        other.selectedDiseaseFilter == selectedDiseaseFilter;
  }

  @override
  int get hashCode {
    return patient.hashCode ^
        selectedTabIndex.hashCode ^
        isLoading.hashCode ^
        selectedDiseaseFilter.hashCode;
  }
}
