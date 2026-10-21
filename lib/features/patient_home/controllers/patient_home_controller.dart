import 'package:flutter/foundation.dart';
import '../models/patient_home_state.dart';
import '../models/patient_model.dart';

/// Hasta ana sayfası ve sekmeler durum yöneticisi
class PatientHomeController extends ValueNotifier<PatientHomeState> {
  PatientHomeController({PatientModel? initialPatient})
      : super(
          PatientHomeState(
            patient: initialPatient ?? PatientModel.mock(),
          ),
        );

  /// Alt navigasyon sekmesini günceller
  void setTabIndex(int index) {
    if (index >= 0 && index <= 3 && value.selectedTabIndex != index) {
      value = value.copyWith(selectedTabIndex: index);
    }
  }

  /// Hastalık etiket filtresini seçer veya kaldırır
  void toggleDiseaseFilter(String disease) {
    if (value.selectedDiseaseFilter == disease) {
      value = value.copyWith(clearFilter: true);
    } else {
      value = value.copyWith(selectedDiseaseFilter: disease);
    }
  }

  /// Hasta bilgilerini günceller
  void updatePatient(PatientModel updated) {
    value = value.copyWith(patient: updated);
  }
}
