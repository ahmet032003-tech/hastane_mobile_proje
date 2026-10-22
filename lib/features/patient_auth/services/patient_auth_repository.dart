import 'package:flutter/foundation.dart';
import '../../patient_home/models/patient_model.dart';

class _RegisteredPatientRecord {
  final String password;
  final PatientModel patient;

  const _RegisteredPatientRecord({
    required this.password,
    required this.patient,
  });
}

/// Hasta hesapları ve kimlik doğrulama yönetim havuzu
class PatientAuthRepository {
  static final PatientAuthRepository instance = PatientAuthRepository._();

  PatientAuthRepository._() {
    _initDefaultUsers();
  }

  factory PatientAuthRepository() => instance;

  final Map<String, _RegisteredPatientRecord> _users = {};

  /// Hasta verisi güncellendiğinde tetiklenen bildirimci
  final ValueNotifier<int> patientUpdatesNotifier = ValueNotifier<int>(0);

  /// Demo varsayılan hasta kayıtları
  void _initDefaultUsers() {
    _users['12345678901'] = _RegisteredPatientRecord(
      password: '123456',
      patient: PatientModel.mock(),
    );

    _users['11111111110'] = const _RegisteredPatientRecord(
      password: '123456',
      patient: PatientModel(
        id: 'patient_002',
        fullName: 'Mehmet Demir',
        tc: '11111111110',
        birthDate: '21 Haziran 1982',
        gender: 'Erkek',
        bloodType: '0 Rh(+)',
        phone: '+90 (533) 222 33 44',
        email: 'mehmet.demir@medauto.health',
        address: 'Barbaros Mah. Ataşehir / İstanbul',
        lastVisitDate: '05 Eylül 2026',
        lastDoctorName: 'Uzm. Dr. Zeynep Kaya',
        lastDoctorBranch: 'Dahiliye Polikliniği',
        heightCm: 178.0,
        weightKg: 78.0,
        activeMedicationCount: 1,
        activeDiseases: ['Gastrit'],
      ),
    );

    _users['24819582014'] = const _RegisteredPatientRecord(
      password: '123456',
      patient: PatientModel(
        id: 'patient_003',
        fullName: 'Fatma Şahin',
        tc: '24819582014',
        birthDate: '03 Mart 1979',
        gender: 'Kadın',
        bloodType: 'B Rh(+)',
        phone: '+90 (535) 987 65 43',
        email: 'fatma.sahin@medauto.health',
        address: 'Acıbadem Mah. Üsküdar / İstanbul',
        lastVisitDate: '22 Ekim 2026',
        lastDoctorName: 'Doç. Dr. Emre Çetin',
        lastDoctorBranch: 'Kardiyoloji Polikliniği 1',
        heightCm: 162.0,
        weightKg: 68.0,
        activeMedicationCount: 0,
        activeDiseases: ['Koroner Arter Hastalığı Riski'],
      ),
    );

    _users['38192049182'] = const _RegisteredPatientRecord(
      password: '123456',
      patient: PatientModel(
        id: 'patient_004',
        fullName: 'Hasan Yurtseven',
        tc: '38192049182',
        birthDate: '12 Kasım 1968',
        gender: 'Erkek',
        bloodType: 'A Rh(-)',
        phone: '+90 (542) 345 67 89',
        email: 'hasan.yurtseven@medauto.health',
        address: 'Koşuyolu Mah. Kadıköy / İstanbul',
        lastVisitDate: '22 Ekim 2026',
        lastDoctorName: 'Doç. Dr. Emre Çetin',
        lastDoctorBranch: 'Kardiyoloji Polikliniği 1',
        heightCm: 174.0,
        weightKg: 82.0,
        activeMedicationCount: 1,
        activeDiseases: ['Esansiyel Hipertansiyon'],
      ),
    );

    _users['51203948172'] = const _RegisteredPatientRecord(
      password: '123456',
      patient: PatientModel(
        id: 'patient_005',
        fullName: 'Zeynep Kaya',
        tc: '51203948172',
        birthDate: '18 Ağustos 1991',
        gender: 'Kadın',
        bloodType: '0 Rh(-)',
        phone: '+90 (531) 234 56 78',
        email: 'zeynep.kaya@medauto.health',
        address: 'Caddebostan Mah. Kadıköy / İstanbul',
        lastVisitDate: '22 Ekim 2026',
        lastDoctorName: 'Doç. Dr. Emre Çetin',
        lastDoctorBranch: 'Kardiyoloji Polikliniği 1',
        heightCm: 166.0,
        weightKg: 59.0,
        activeMedicationCount: 0,
        activeDiseases: ['Aritmi Şüphesi'],
      ),
    );
  }

  /// T.C. Kimlik Numarası sistemde kayıtlı mı?
  bool isTcRegistered(String tc) {
    return _users.containsKey(tc.trim());
  }

  /// Kimlik doğrulama (Giriş)
  PatientModel? authenticate(String tc, String password) {
    final record = _users[tc.trim()];
    if (record != null && record.password == password.trim()) {
      return record.patient;
    }
    return null;
  }

  /// Yeni hasta kaydı oluştur
  bool registerPatient({
    required PatientModel patient,
    required String password,
  }) {
    final sanitizedTc = patient.tc.trim();
    if (_users.containsKey(sanitizedTc)) {
      return false; // Zaten kayıtlı
    }

    _users[sanitizedTc] = _RegisteredPatientRecord(
      password: password.trim(),
      patient: patient,
    );
    return true;
  }

  /// T.C. numarasına göre hasta modelini getir
  PatientModel? getPatient(String tc) => _users[tc.trim()]?.patient;

  /// Mevcut şifreyi doğrula
  bool verifyPassword(String tc, String password) {
    final record = _users[tc.trim()];
    return record != null && record.password == password.trim();
  }

  /// Şifre güncelleme (mevcut şifre doğrulanarak)
  bool updatePassword(String tc, String oldPassword, String newPassword) {
    final sanitizedTc = tc.trim();
    final record = _users[sanitizedTc];
    if (record == null) return false;
    if (record.password != oldPassword.trim()) return false;

    _users[sanitizedTc] = _RegisteredPatientRecord(
      password: newPassword.trim(),
      patient: record.patient,
    );
    return true;
  }

  /// Hasta klinik veya kişisel verilerini güncelle (ör: boy, kilo, aktif ilaç sayısı)
  void updatePatientData(PatientModel updated) {
    final sanitizedTc = updated.tc.trim();
    final record = _users[sanitizedTc];
    if (record != null) {
      _users[sanitizedTc] = _RegisteredPatientRecord(
        password: record.password,
        patient: updated,
      );
    } else {
      _users[sanitizedTc] = _RegisteredPatientRecord(
        password: '123456',
        patient: updated,
      );
    }
    patientUpdatesNotifier.value++;
  }

  /// Testler için durum sıfırlama
  @visibleForTesting
  void reset() {
    _users.clear();
    _initDefaultUsers();
  }
}
