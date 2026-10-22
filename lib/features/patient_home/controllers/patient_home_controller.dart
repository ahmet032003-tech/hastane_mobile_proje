import 'package:flutter/foundation.dart';
import '../../medications/services/medication_repository.dart';
import '../../patient_auth/services/patient_auth_repository.dart';
import '../models/patient_home_state.dart';
import '../models/patient_model.dart';

/// Hasta ana sayfası ve sekmeler durum yöneticisi
class PatientHomeController extends ValueNotifier<PatientHomeState> {
  final MedicationRepository _medicationRepository;
  final PatientAuthRepository _authRepository;
  bool _isDisposed = false;

  PatientHomeController({
    PatientModel? initialPatient,
    MedicationRepository? medicationRepository,
    PatientAuthRepository? authRepository,
  })  : _medicationRepository =
            medicationRepository ?? MedicationRepository.instance,
        _authRepository = authRepository ?? PatientAuthRepository.instance,
        super(
          PatientHomeState(
            patient: initialPatient ?? PatientModel.mock(),
          ),
        ) {
    _syncMedicationCount();
    _medicationRepository.medicationsNotifier.addListener(_syncMedicationCount);
    _authRepository.patientUpdatesNotifier.addListener(_syncPatientFromAuth);
  }

  void _syncMedicationCount() {
    if (_isDisposed) return;
    final tc = value.patient.tc;
    final count = _medicationRepository.getActiveMedicationCount(tc);
    if (value.patient.activeMedicationCount != count) {
      final updated = value.patient.copyWith(activeMedicationCount: count);
      updatePatient(updated);
      _authRepository.updatePatientData(updated);
    }
  }

  void _syncPatientFromAuth() {
    if (_isDisposed) return;
    final latest = _authRepository.getPatient(value.patient.tc);
    if (latest != null && latest != value.patient) {
      updatePatient(latest);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _medicationRepository.medicationsNotifier.removeListener(_syncMedicationCount);
    _authRepository.patientUpdatesNotifier.removeListener(_syncPatientFromAuth);
    super.dispose();
  }

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
