import 'package:flutter/foundation.dart';
import '../../patient_home/models/patient_model.dart';
import '../models/patient_register_state.dart';
import '../services/patient_auth_repository.dart';

/// Hasta kayıt işlemleri ve form durum yönetim denetleyicisi
class PatientRegisterController extends ValueNotifier<PatientRegisterState> {
  final PatientAuthRepository _authRepository;

  PatientRegisterController({
    PatientRegisterState? initialState,
    PatientAuthRepository? authRepository,
  })  : _authRepository = authRepository ?? PatientAuthRepository.instance,
        super(initialState ?? const PatientRegisterState());

  /// T.C. Kimlik Numarasını günceller
  void setTc(String tc) {
    final sanitized = tc.replaceAll(RegExp(r'[^0-9]'), '');
    final limited = sanitized.length > 11 ? sanitized.substring(0, 11) : sanitized;

    value = value.copyWith(
      tc: limited,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Ad ve Soyadı günceller
  void setFullName(String fullName) {
    value = value.copyWith(
      fullName: fullName,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Telefon numarasını günceller
  void setPhone(String phone) {
    value = value.copyWith(
      phone: phone,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// E-posta adresini günceller
  void setEmail(String email) {
    value = value.copyWith(
      email: email.trim(),
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Doğum tarihini günceller
  void setBirthDate(String birthDate) {
    value = value.copyWith(
      birthDate: birthDate,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Cinsiyeti günceller
  void setGender(String gender) {
    value = value.copyWith(
      gender: gender,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Kan grubunu günceller
  void setBloodType(String bloodType) {
    value = value.copyWith(
      bloodType: bloodType,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Adresi günceller
  void setAddress(String address) {
    value = value.copyWith(
      address: address,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Şifreyi günceller
  void setPassword(String password) {
    value = value.copyWith(
      password: password,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Şifre tekrarını günceller
  void setPasswordConfirm(String confirm) {
    value = value.copyWith(
      passwordConfirm: confirm,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// Şifre görünürlüğünü açar / kapatır
  void togglePasswordVisibility() {
    value = value.copyWith(
      isPasswordVisible: !value.isPasswordVisible,
    );
  }

  /// Şifre tekrarı görünürlüğünü açar / kapatır
  void togglePasswordConfirmVisibility() {
    value = value.copyWith(
      isPasswordConfirmVisible: !value.isPasswordConfirmVisible,
    );
  }

  /// KVKK kabul durumunu günceller
  void setKvkkAccepted(bool accepted) {
    value = value.copyWith(
      isKvkkAccepted: accepted,
      clearErrorMessage: true,
      status: PatientRegisterStatus.initial,
    );
  }

  /// T.C. Kimlik No algoritma doğrulaması
  bool _isValidTc(String tc) {
    if (tc.length != 11) return false;
    if (!RegExp(r'^[1-9][0-9]{10}$').hasMatch(tc)) return false;

    final digits = tc.split('').map(int.parse).toList();
    final sumOdd = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    final sumEven = digits[1] + digits[3] + digits[5] + digits[7];
    final tenthDigit = ((sumOdd * 7) - sumEven) % 10;
    final eleventhDigit = (digits.take(10).reduce((a, b) => a + b)) % 10;

    final isAlgorithmValid =
        digits[9] == tenthDigit && digits[10] == eleventhDigit;
    final isDemoTc = tc == '12345678901' || tc == '11111111110';

    return isAlgorithmValid || isDemoTc;
  }

  /// E-posta biçim kontrolü
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Kayıt işlemini doğrular ve tamamlar
  Future<bool> register() async {
    final tc = value.tc.trim();
    final fullName = value.fullName.trim();
    final phone = value.phone.trim();
    final email = value.email.trim();
    final birthDate = value.birthDate.trim();
    final password = value.password.trim();
    final passwordConfirm = value.passwordConfirm.trim();

    // 1. T.C. Kimlik No Kontrolleri
    if (tc.isEmpty) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage: 'Lütfen 11 haneli T.C. Kimlik Numaranızı giriniz.',
      );
      return false;
    }

    if (tc.length != 11 || !_isValidTc(tc)) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage: 'Geçersiz T.C. Kimlik Numarası. Lütfen kontrol ediniz.',
      );
      return false;
    }

    if (_authRepository.isTcRegistered(tc)) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage:
            'Bu T.C. Kimlik Numarası ile zaten kayıtlı bir hasta hesabı bulunmaktadır. Lütfen giriş yapınız.',
      );
      return false;
    }

    // 2. Ad Soyad Kontrolleri
    if (fullName.isEmpty || fullName.length < 3) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage: 'Lütfen adınızı ve soyadınızı eksiksiz giriniz.',
      );
      return false;
    }

    // 3. Telefon Kontrolleri
    final sanitizedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (sanitizedPhone.length < 10) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage:
            'Lütfen geçerli bir telefon numarası giriniz (En az 10 hane).',
      );
      return false;
    }

    // 4. E-posta Kontrolleri
    if (email.isNotEmpty && !_isValidEmail(email)) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage: 'Lütfen geçerli bir e-posta adresi giriniz.',
      );
      return false;
    }

    // 5. Doğum Tarihi Kontrolleri
    if (birthDate.isEmpty) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage: 'Lütfen doğum tarihinizi seçiniz.',
      );
      return false;
    }

    // 6. Şifre Kontrolleri
    if (password.isEmpty) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage: 'Lütfen hesabınız için bir şifre belirleyiniz.',
      );
      return false;
    }

    if (password.length < 6) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage: 'Şifreniz en az 6 karakter olmalıdır.',
      );
      return false;
    }

    if (password != passwordConfirm) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage: 'Girilen şifreler birbiriyle eşleşmiyor.',
      );
      return false;
    }

    // 7. KVKK Onayı
    if (!value.isKvkkAccepted) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage:
            'Lütfen KVKK ve Hasta Hakları Aydınlatma Metni\'ni onaylayınız.',
      );
      return false;
    }

    // Yükleniyor durumuna geçir
    value = value.copyWith(
      status: PatientRegisterStatus.loading,
      clearErrorMessage: true,
    );

    // Kayıt simülasyonu
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final newPatient = PatientModel(
      id: 'patient_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      tc: tc,
      birthDate: birthDate,
      gender: value.gender,
      bloodType: value.bloodType,
      phone: phone,
      email: email.isEmpty ? '$tc@medauto.health' : email,
      address: value.address.trim().isEmpty
          ? 'Kadıköy / İstanbul'
          : value.address.trim(),
      lastVisitDate: 'Yeni Hasta Kaydı',
      lastDoctorName: 'Belirtilmedi',
      lastDoctorBranch: 'Genel Poliklinik',
      heightCm: 172.0,
      weightKg: 68.0,
      activeMedicationCount: 0,
      activeDiseases: const [],
    );

    final isRegistered = _authRepository.registerPatient(
      patient: newPatient,
      password: password,
    );

    if (!isRegistered) {
      value = value.copyWith(
        status: PatientRegisterStatus.failure,
        errorMessage:
            'Kayıt tamamlanamadı. Bu T.C. numarası sistemde mevcut olabilir.',
      );
      return false;
    }

    value = value.copyWith(
      status: PatientRegisterStatus.success,
      clearErrorMessage: true,
      registeredPatient: newPatient,
    );
    return true;
  }
}
