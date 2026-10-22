import 'package:flutter/foundation.dart';
import '../../patient_auth/services/patient_auth_repository.dart';
import '../models/medication_model.dart';

/// İlaç ve Reçete Yönetim Servisi (Doktor ataması ve hasta profili senkronizasyonu)
class MedicationRepository {
  static final MedicationRepository instance = MedicationRepository._();

  MedicationRepository._() {
    _initDefaults();
  }

  factory MedicationRepository() => instance;

  final ValueNotifier<List<MedicationModel>> medicationsNotifier =
      ValueNotifier<List<MedicationModel>>([]);

  void _initDefaults() {
    medicationsNotifier.value = MedicationModel.mockList();
  }

  List<MedicationModel> get medications => medicationsNotifier.value;

  /// Belirli bir hastaya ait ilaçları getirir (T.C. numarasına göre filtrelenmiş)
  List<MedicationModel> getMedicationsForPatient(String? tc) {
    if (tc == null || tc.trim().isEmpty) {
      return medicationsNotifier.value;
    }
    final sanitizedTc = tc.trim();
    return medicationsNotifier.value.where((m) {
      return m.patientTc == null || m.patientTc == sanitizedTc;
    }).toList();
  }

  /// Belirli bir hastanın aktif kullanılan ilaç sayısı
  int getActiveMedicationCount(String? tc) {
    return getMedicationsForPatient(tc).where((m) => m.isActive).length;
  }

  /// Doktor tarafından hastaya yeni aktif ilaç reçete edilmesi
  MedicationModel prescribeMedication({
    required String patientTc,
    required String patientName,
    required String medicineName,
    required String dosage,
    required String usageInstructions,
    String doctorName = 'Doç. Dr. Emre Çetin',
    String doctorBranch = 'Kardiyoloji Polikliniği',
    String diseaseReason = 'Kardiyovasküler Tedavi',
    String instructionsDetail =
        'Hekim reçetesine uygun olarak düzenli kullanılmalıdır.',
    int boxCount = 1,
    bool isActive = true,
  }) {
    final now = DateTime.now();
    final d = now.day.toString().padLeft(2, '0');
    final m = now.month.toString().padLeft(2, '0');
    final expiryYear = now.year + 1;

    final newMed = MedicationModel(
      id: 'med_${now.millisecondsSinceEpoch}_${medicationsNotifier.value.length}',
      name: medicineName.trim(),
      prescribedDate: now,
      expiryDate: '$d.$m.$expiryYear',
      doctorName: doctorName,
      doctorBranch: doctorBranch,
      diseaseReason: diseaseReason,
      usageInstructions: usageInstructions,
      dosage: dosage,
      boxCount: boxCount,
      barcode:
          '8699${now.millisecondsSinceEpoch.toString().padRight(9, '0').substring(0, 9)}',
      instructionsDetail: instructionsDetail,
      isActive: isActive,
      patientTc: patientTc.trim(),
    );

    final updated = [newMed, ...medicationsNotifier.value];
    medicationsNotifier.value = updated;

    _syncPatientRecord(patientTc, doctorName, doctorBranch);

    return newMed;
  }

  /// E-Reçete masasından çoklu ilaç ataması yapılması
  List<MedicationModel> prescribeMedications({
    required String patientTc,
    required String patientName,
    required List<Map<String, String>> medicines,
    String doctorName = 'Doç. Dr. Emre Çetin',
    String doctorBranch = 'Kardiyoloji Polikliniği',
    String defaultDisease = 'Kardiyovasküler Tedavi',
  }) {
    final now = DateTime.now();
    final d = now.day.toString().padLeft(2, '0');
    final m = now.month.toString().padLeft(2, '0');
    final expiryYear = now.year + 1;

    final List<MedicationModel> newItems = [];

    for (int i = 0; i < medicines.length; i++) {
      final item = medicines[i];
      final name = item['name'] ?? '';
      if (name.trim().isEmpty) continue;

      final dosage = item['dosage'] ?? 'Günde 1 Defa';
      final boxesStr = item['boxes'] ?? '1 Kutu';
      final boxCount = int.tryParse(boxesStr.replaceAll(RegExp(r'\D'), '')) ?? 1;

      final med = MedicationModel(
        id: 'med_${now.millisecondsSinceEpoch}_$i',
        name: name.trim(),
        prescribedDate: now,
        expiryDate: '$d.$m.$expiryYear',
        doctorName: doctorName,
        doctorBranch: doctorBranch,
        diseaseReason: item['reason'] ?? defaultDisease,
        usageInstructions: dosage,
        dosage: dosage,
        boxCount: boxCount,
        barcode:
            '8699${(now.millisecondsSinceEpoch + i).toString().padRight(9, '0').substring(0, 9)}',
        instructionsDetail:
            'Hekim reçetesine uygun olarak düzenli kullanılmalıdır.',
        isActive: true,
        patientTc: patientTc.trim(),
      );

      newItems.add(med);
    }

    if (newItems.isNotEmpty) {
      final updated = [...newItems, ...medicationsNotifier.value];
      medicationsNotifier.value = updated;
      _syncPatientRecord(patientTc, doctorName, doctorBranch);
    }

    return newItems;
  }

  /// Hasta hesabının aktif ilaç sayısını ve son hekim bilgisini senkronize et
  void _syncPatientRecord(
      String patientTc, String doctorName, String doctorBranch) {
    final sanitizedTc = patientTc.trim();
    final patient = PatientAuthRepository.instance.getPatient(sanitizedTc);
    if (patient != null) {
      final activeCount = getActiveMedicationCount(sanitizedTc);
      final updatedPatient = patient.copyWith(
        activeMedicationCount: activeCount,
        lastDoctorName: doctorName,
        lastDoctorBranch: doctorBranch,
      );
      PatientAuthRepository.instance.updatePatientData(updatedPatient);
    }
  }

  @visibleForTesting
  void reset() {
    _initDefaults();
  }
}
